# 05 — Production: From Personal Setup to Team Deployment

> 🔴 **Advanced** — You've got local LLMs running on your machine. Now let's make them available to your team, your apps, and your users — securely and reliably.

---

## What You'll Learn

By the end of this chapter, you'll be able to:

- ✅ Set up **multi-user access** with Open WebUI (users, groups, permissions)
- ✅ Expose Ollama models via **REST API** with rate limiting and authentication
- ✅ Deploy the full stack (Ollama + Open WebUI + RAG) using **Docker**
- ✅ Monitor **usage, performance, and errors**
- ✅ Calculate **when local beats the cloud** — with real 2026 pricing
- ✅ Secure your deployment with an **actionable checklist**

---

## 1. Multi-User Management with Open WebUI

Open WebUI isn't just a pretty interface — it comes with a built-in user management system. Here's how to set it up for multiple users.

### Enabling Sign-Up

By default, Open WebUI allows anyone to create an account. For team use, you'll want to control this:

```bash
# Option A: Allow sign-up (good for small teams)
docker run -d -p 3000:8080 \
  -v open-webui:/app/backend/data \
  -e OLLAMA_BASE_URL=http://host.docker.internal:11434 \
  -e WEBUI_NAME="Team AI" \
  -e ENABLE_SIGNUP=true \
  --name open-webui --restart always \
  ghcr.io/open-webui/open-webui:main
```

> The `--restart always` flag means the container auto-starts when the machine reboots. Without it, your team loses access every time you restart.

```bash
# Option B: Invite-only (recommended for production)
# Same as above, but set:
-e ENABLE_SIGNUP=false
```

With sign-up disabled, you create accounts manually from the Admin Panel (`Settings → Users → Add User`).

### Creating User Roles

Open WebUI supports three roles out of the box:

| Role | Permissions | Best For |
|------|------------|----------|
| **User** | Chat with assigned models, create conversations | Team members who just need to use AI |
| **Admin** | Full access: manage users, models, settings | Team leads, IT admins |
| **Pending** | Can't chat yet — awaiting approval | New sign-ups waiting for review |

**How to assign roles:**
1. Log in as admin → click the gear icon ⚙️ (bottom left)
2. Navigate to **Admin Panel → Users**
3. Click the pencil icon on any user → change their role

### Model Access Control (Per-User Models)

This is one of Open WebUI's killer features for production use. You can control **which models each user can see and use**:

1. Admin Panel → **Models**
2. Click a model → **Permissions** tab
3. Select which users/groups can access it

**Why this matters:** You might have a 70B model that only your power users should run (saves VRAM for everyone), or a cheap 7B model for general queries. Per-user model access lets you balance resources intelligently.

---

## 2. API Deployment: Exposing Ollama to Applications

Ollama runs an HTTP server on `http://localhost:11434` by default. To make it accessible to other applications (or other machines on your network), you need to configure it properly.

### Step 1: Allow External Connections

By default, Ollama only listens on `127.0.0.1` (localhost). To allow network access:

**Linux (systemd):**
```bash
# Edit the Ollama service configuration
sudo mkdir -p /etc/systemd/system/ollama.service.d
cat > /etc/systemd/system/ollama.service.d/override.conf << 'EOF'
[Service]
Environment="OLLAMA_HOST=0.0.0.0:11434"
EOF

# Reload and restart
sudo systemctl daemon-reload
sudo systemctl restart ollama
```

> `0.0.0.0` means "listen on all network interfaces." `127.0.0.1` means "listen on localhost only."

**macOS:** Set the environment variable in your shell profile:
```bash
# Add to ~/.zshrc or ~/.bashrc
export OLLAMA_HOST=0.0.0.0:11434
# Then restart Ollama from the menu bar icon
```

**Docker Ollama:**
```bash
docker run -d \
  -p 11434:11434 \
  -v ollama:/root/.ollama \
  --name ollama \
  --restart always \
  ollama/ollama
```

### Step 2: Add Authentication (htpasswd)

⚠️ **Never expose Ollama to the public internet without authentication.** Anyone who finds your endpoint can run models on your GPU, costing you electricity and compute.

The simplest auth layer is **Basic Auth** via a reverse proxy:

```bash
# Install nginx and create a password file
sudo apt-get install nginx apache2-utils
sudo htpasswd -c /etc/nginx/.htpasswd admin
# Enter a strong password when prompted

# Optional: add more users
sudo htpasswd /etc/nginx/.htpasswd teammate1
```

### Step 3: Set Up Nginx Reverse Proxy

```nginx
# /etc/nginx/sites-available/ollama
server {
    listen 8080;
    server_name _;

    # === Authentication ===
    # Every request must provide a valid username:password
    auth_basic "Ollama API — Authorized Access Only";
    auth_basic_user_file /etc/nginx/.htpasswd;

    # === Rate Limiting ===
    # Max 30 requests per minute per IP address
    limit_req zone=ollama burst=5 nodelay;
    limit_req_status 429;

    location / {
        proxy_pass http://127.0.0.1:11434;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;

        # Increase timeout for long-running model generations
        proxy_read_timeout 300;
        proxy_send_timeout 300;
    }
}

# Define the rate limit zone (in http block, usually /etc/nginx/nginx.conf)
# limit_req_zone $binary_remote_addr zone=ollama:10m rate=30r/m;
```

**What each directive does:**
- `auth_basic` — Prompts for username/password on every request
- `limit_req` — Prevents a single user from overwhelming your GPU
- `proxy_read_timeout 300` — Models can take minutes to generate; this keeps the connection open

```bash
# Enable the site and restart nginx
sudo ln -s /etc/nginx/sites-available/ollama /etc/nginx/sites-enabled/
sudo nginx -t  # Test config for syntax errors
sudo systemctl restart nginx
```

### Step 4: Test Your API

```bash
# Without auth — should get 401 Unauthorized
curl -sk http://your-server-ip:8080/api/tags

# With auth — should work
curl -sk -u admin:yourpassword http://your-server-ip:8080/api/tags

# Send a chat request via API
curl -sk -u admin:yourpassword \
  -X POST http://your-server-ip:8080/api/chat \
  -d '{
    "model": "qwen2.5:7b",
    "messages": [{"role": "user", "content": "Say hello in one word"}],
    "stream": false
  }'
```

> The `stream: false` parameter returns the full response at once. For production apps, you'll want `stream: true` for streaming responses.

### Step 5: OpenAI-Compatible Endpoint

Ollama also exposes an OpenAI-compatible endpoint, which means any tool that works with OpenAI's API can work with your local models:

```bash
# Using the OpenAI Python library with Ollama
curl -sk -u admin:yourpassword \
  -X POST http://your-server-ip:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen2.5:7b",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

**Compatibility note:** The OpenAI-compatible endpoint (`/v1/`) works with most tools that support OpenAI — including **LangChain, LlamaIndex, Continue.dev (VS Code extension), Cursor, and custom scripts**. Just change the base URL and skip the API key (or use a dummy one if the tool requires it).

---

## 3. Docker Deployment: Full Stack, Containerized

This section has two versions. Start with the **quick version** to get running fast, then use the **deep version** when you need a proper production setup.

### Quick Version: `docker run`

Run each component individually. Good for testing and single-user setups:

```bash
# 1. Ollama (model server)
docker run -d \
  -p 11434:11434 \
  -v ollama:/root/.ollama \
  --name ollama \
  --restart always \
  ollama/ollama

# What this does:
# - `-d` → run in background (detached mode)
# - `-p 11434:11434` → map port 11434 from container to your machine
# - `-v ollama:/root/.ollama` → save models to a persistent volume
#    (without this, models disappear when the container is recreated)
# - `--restart always` → auto-start on boot and after crashes

# 2. Open WebUI (chat interface, connects to Ollama)
docker run -d \
  -p 3000:8080 \
  -v open-webui:/app/backend/data \
  -e OLLAMA_BASE_URL=http://ollama:11434 \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main

# If Ollama and WebUI are on different machines:
# -e OLLAMA_BASE_URL=http://YOUR_SERVER_IP:11434
```

### Deep Version: `docker-compose` (Production-Ready)

Create a file called `docker-compose.yml` in your project directory:

```yaml
version: "3.8"

services:
  # === Model Server ===
  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    restart: always
    ports:
      - "11434:11434"
    volumes:
      - ollama_data:/root/.ollama
    environment:
      - OLLAMA_HOST=0.0.0.0:11434
    # 🖥️ GPU support (remove this section if you don't have NVIDIA GPU)
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]

  # === Web Interface ===
  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    container_name: open-webui
    restart: always
    ports:
      - "3000:8080"
    volumes:
      - open_webui_data:/app/backend/data
    environment:
      - OLLAMA_BASE_URL=http://ollama:11434
      - WEBUI_NAME=My Local AI
      - ENABLE_SIGNUP=false
    depends_on:
      - ollama

  # === Optional: AnythingLLM (RAG) ===
  anythingllm:
    image: mintplexlabs/anythingllm:latest
    container_name: anythingllm
    restart: always
    ports:
      - "3001:3001"
    volumes:
      - anythingllm_data:/app/server/storage
    environment:
      - LLM_PROVIDER=ollama
      - OLLAMA_BASE_PATH=http://ollama:11434
      - OLLAMA_MODEL_PREF=qwen2.5:7b
      - EMBEDDING_PROVIDER=ollama
      - OLLAMA_EMBEDDING_MODEL=qwen2.5:7b
    depends_on:
      - ollama

volumes:
  ollama_data:
  open_webui_data:
  anythingllm_data:
```

**How to use it:**
```bash
# Start everything
cd /path/to/your/project
docker compose up -d

# Check if containers are running
docker compose ps

# View logs
docker compose logs -f ollama

# Pull a model
docker exec ollama ollama pull qwen2.5:7b

# Stop everything
docker compose down

# Update images (when new versions are available)
docker compose pull
docker compose up -d
```

> **Line-by-line explanation of the compose file:**
> - `services:` — Each service is a separate container
> - `ollama:` / `open-webui:` — Service names; Open WebUI uses `http://ollama:11434` to connect because Docker Compose creates an internal network where service names act as hostnames
> - `volumes:` — Persistent storage that survives container recreation
> - `depends_on:` — Wait for Ollama to start before starting Open WebUI
> - `deploy.resources` — GPU passthrough (only works with `nvidia-container-toolkit` installed)

### Docker Tips for Different Platforms

| Platform | Path Mounting | GPU Support | Notes |
|----------|--------------|-------------|-------|
| **Linux** | `/home/user/data:/data` | ✅ NVIDIA (`nvidia-container-toolkit`) | Easiest setup |
| **macOS** | `~/Documents/data:/data` | ❌ (no GPU passthrough to Docker) | Models run slower (CPU only in Docker) |
| **Windows** | `C:\data:/data` | ✅ NVIDIA (requires WSL2 backend) | Use `\` path separators in Docker |

> **macOS users:** Docker Desktop doesn't support GPU passthrough. For GPU-accelerated Ollama on Mac, **run Ollama natively** (outside Docker) and point your Dockerized Open WebUI to it via `OLLAMA_BASE_URL=http://host.docker.internal:11434`.

---

## 4. Monitoring & Logging

You don't need a full observability stack. A few simple checks will tell you most of what you need.

### Quick Health Check

```bash
# Check if Ollama is running
curl -s http://localhost:11434/api/tags | python3 -c "import sys,json; models=json.load(sys.stdin); print(f'{len(models[\"models\"])} models loaded')"

# Check GPU usage (NVIDIA only)
watch -n 2 nvidia-smi

# Check RAM usage
free -h

# Check Docker container status
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

### Basic Logging Setup

Ollama logs to stdout. If you're running it in Docker, logs are already captured:

```bash
# See real-time Ollama logs
docker logs -f ollama

# See Open WebUI logs
docker logs -f open-webui

# Save logs to a file (searchable later)
docker logs ollama > ~/ollama-logs-$(date +%Y%m%d).txt 2>&1
```

### What to Watch For

| Metric | Normal Range | Red Flag | What To Do |
|--------|-------------|----------|------------|
| GPU VRAM usage | 70–95% | 100% (OOM) | Use smaller model or lower quantization |
| GPU temperature | 65–80°C | >85°C | Clean fans, reduce ambient temp, lower power limit |
| Response time (7B model) | 1–5 seconds | >15 seconds | Check VRAM, restart Ollama, reduce concurrent users |
| RAM usage | Within available | Swap usage >0 | Add more RAM or reduce model count |

### Usage Tracking (Who's Using What)

Open WebUI's admin panel provides basic usage statistics:
- **Admin Panel → Chat Logs** — See conversations (toggle anonymization for privacy)
- **Admin Panel → Users** — See active users
- **Settings → Models** — See which models are most popular

For more detailed tracking, add a simple log parser:

```bash
# Count API requests per hour from Ollama logs
docker logs ollama 2>&1 | grep "\[API\]" | \
  awk '{print $1}' | cut -d: -f1 | sort | uniq -c | sort -rn | head -10
```

---

## 5. Cost Analysis: Local vs Cloud (Updated for 2026)

> 💰 *All estimates based on US average electricity rate ($0.15/kWh). Hardware prices as of May 2026. Actual costs vary by region.*

### The Full Picture

| Scenario | Cloud (GPT-4o / Claude) | Local (Your Hardware) | Winner |
|----------|------------------------|----------------------|--------|
| **Solo heavy user** ($200/mo API) | $2,400/year | **$325/year** (electricity) | Local after **14 months** |
| **Small team (5 people)** | $1,000/month ($200×5) | **$380/year** (electricity) | Local after **~6 months** |
| **Light user** (<$50/mo API) | $600/year | **$0** (existing hardware) | Local immediately |
| **Enterprise (50 users)** | Custom pricing (~$20K/yr) | $3,500 (one-time build) + $600/yr | Local from **month 1** |

### Detailed Breakdown: Solo Heavy User

```bash
# === Local Setup — One-Time Cost ===
RTX 4090 (or used RTX 3090)  $1,500–2,500
Rest of PC (if needed)        $500–1,000
Total upfront:                $2,000–3,500

# === Local — Monthly Costs ===
Electricity (0.4 kWh × 8h/day × $0.15)  ~$18/month
Internet (negligible)                    $0
Total monthly:                           ~$18/month

# === Cloud — Monthly Costs ===
ChatGPT Pro / Claude Pro                 $200/month
API calls (heavy user)                   $50–100/month
Total monthly:                           $200–300/month
```

### Break-Even Calculator

Here's a simple way to calculate your personal break-even point:

```
Break-even (months) = Hardware Cost / (Cloud monthly cost - Local monthly cost)

Example with RTX 4090 ($2,500) vs ChatGPT Pro ($200):
$2,500 / ($200 - $18) = 13.7 months
```

> After the break-even point, you're **saving $182/month** compared to the cloud. Over 3 years: **$4,800 in savings** (minus hardware depreciation).

### When Cloud Still Makes Sense

Let's be honest — local isn't always better:

| Situation | Recommendation |
|-----------|---------------|
| You need GPT-4o / Claude Opus quality | Keep a cloud subscription for hard tasks |
| Your GPU is <8GB VRAM | Use local for simple tasks, cloud for complex ones |
| You have zero upfront budget | Start with cloud, save for hardware |
| You need 100% uptime (SLA) | Cloud wins — your home power goes out sometimes |
| You process huge batches overnight | Local — no API limits, no per-token cost |

**The hybrid approach** is what I personally recommend:
- **Daily use** → Local LLM (Qwen 2.5:7b or DeepSeek-R1:14b)
- **Hard tasks** → Cloud API (pay-per-use, ~$20–50/month)
- **Automated batch jobs** → Local (unlimited, no rate limits)

---

## 6. Security Checklist

⚠️ **This is the most important section in this chapter.** An exposed, unauthenticated Ollama instance is a liability.

### Before Going Live

- [ ] **Ollama is NOT directly exposed to the internet**
  - Verify: `curl -s http://YOUR_PUBLIC_IP:11434/api/tags` should **fail** from outside
  - If it succeeds → your Ollama is visible to the entire internet!

- [ ] **Authentication is enabled** (htpasswd / API key / SSO)
  - Verify: `curl -u test:test http://localhost:8080/api/tags` returns 401

- [ ] **SSH / VPN only for remote access**
  - Best practice: Don't expose the API at all. Use **Tailscale** or **WireGuard** VPN

- [ ] **Firewall rules are configured**
  ```bash
  # Allow only local network access (192.168.x.x)
  sudo ufw allow from 192.168.0.0/16 to any port 11434
  sudo ufw deny 11434  # Block external access

  # If using nginx reverse proxy (port 8080), allow from VPN only
  sudo ufw allow from 10.0.0.0/8 to any port 8080
  ```

- [ ] **Ollama version is up to date**
  ```bash
  ollama --version
  # Compare with https://github.com/ollama/ollama/releases
  ```

- [ ] **Docker containers restart on failure**
  - Verify: `docker inspect ollama | grep -A2 RestartPolicy`

### Quick Security Audit Script

```bash
#!/bin/bash
# save as: security-audit.sh && chmod +x security-audit.sh

echo "=== Local LLM Security Audit ==="

# Check 1: Is Ollama exposed?
EXTERNAL_CHECK=$(curl -s -o /dev/null -w "%{http_code}" \
  http://localhost:11434/api/tags 2>/dev/null)
if [ "$EXTERNAL_CHECK" == "200" ]; then
  echo "⚠️  Ollama API is accessible (port 11434)"
  echo "   If this machine has a public IP, the world can run models on your GPU!"
else
  echo "✅ Ollama API is not accessible"
fi

# Check 2: Is there authentication?
AUTH_CHECK=$(curl -s -o /dev/null -w "%{http_code}" \
  http://localhost:8080/api/tags 2>/dev/null)
if [ "$AUTH_CHECK" == "401" ]; then
  echo "✅ Reverse proxy auth is working"
elif [ "$AUTH_CHECK" == "200" ]; then
  echo "⚠️  No authentication on port 8080"
else
  echo "ℹ️  No reverse proxy detected on port 8080"
fi

# Check 3: Firewall status
if command -v ufw &>/dev/null; then
  echo "--- UFW Status ---"
  sudo ufw status verbose
fi

# Check 4: GPU usage (snapshot)
if command -v nvidia-smi &>/dev/null; then
  echo "--- GPU ---"
  nvidia-smi --query-gpu=name,memory.used,memory.total,temperature.gpu \
    --format=csv,noheader
fi
```

> Run this script periodically or set it up as a cron job: `*/30 * * * * /path/to/security-audit.sh`

### Your Production Deployment Cheat Sheet

```
                 ┌──────────────┐
                 │   Internet   │
                 └──────┬───────┘
                        │
                 ┌──────▼───────┐     ┌──────────────┐
                 │  Nginx Proxy │────▶│ htpasswd Auth │
                 │  (port 8080) │     └──────────────┘
                 └──────┬───────┘
                        │ (internal network only)
                 ┌──────▼───────┐
                 │    Ollama    │
                 │  (port 11434)│
                 └──────┬───────┘
                        │
              ┌─────────┼─────────┐
              │         │         │
       ┌──────▼──┐ ┌───▼────┐ ┌──▼──────┐
       │Open WebUI│ │Anything│ │ Custom  │
       │ (3000)  │ │ LLM    │ │  Apps   │
       └─────────┘ └────────┘ └─────────┘
```

---

## What's Next

You've gone from "running a model in the terminal" to a **production-ready AI server** that your team can use. 

In **[Chapter 6 → Function Calling & Tool Use](../06-function-calling/README.md)**, we'll make your local LLM actually **do things** — call APIs, interact with databases, and control other software.

---

*Found this useful? ⭐ [Star the repo](https://github.com/Lingdas1/local-llm-guide) — it helps others find it and you'll get notified when new chapters drop.*
