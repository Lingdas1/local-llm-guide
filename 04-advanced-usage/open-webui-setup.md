# Open WebUI: Your Local ChatGPT

> **Transform your local LLM into a beautiful, full-featured web interface — like ChatGPT, but running entirely on your machine.**

## What Is Open WebUI?

Open WebUI is a self-hosted web interface for Ollama. It gives you:

- 🖥️ A ChatGPT-like chat interface in your browser
- 🔄 Switch between models mid-conversation
- 📁 Upload documents and chat with them (RAG)
- 🖼️ Image generation (via Automatic1111 / ComfyUI)
- 🎤 Voice input / text-to-speech
- 👥 Multi-user support (share with family or team)
- 📱 Mobile-friendly (works on phone browsers)
- 🔌 Plugins for images, web search, and more

**Best of all:** It connects to your local Ollama instance — no data ever leaves your machine.

---

## Prerequisites

- ✅ Ollama installed and working (see [Getting Started](../01-getting-started/))
- ✅ At least one model pulled (e.g., `qwen2.5:7b`)
- ✅ Docker installed (recommended) **OR** Python 3.11+

---

## Option A: Install with Docker (Recommended — 2 Minutes)

Docker is the easiest way. One command and you're done:

```bash
docker run -d \
  -p 3000:8080 \
  -v open-webui:/app/backend/data \
  -e OLLAMA_BASE_URL=http://host.docker.internal:11434 \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main
```

**What this does:**
- `-p 3000:8080` — makes it available at `http://localhost:3000`
- `-v open-webui:/app/backend/data` — keeps your chats saved even if you restart
- `-e OLLAMA_BASE_URL` — tells it where your Ollama is running
- `--restart always` — auto-starts when your computer boots

### Verify It's Running

```bash
# Check logs — you should see "Application startup complete"
docker logs open-webui --tail 20
```

Then open **http://localhost:3000** in your browser.

> **First time?** Create an account. Don't worry — it's local only. Your data stays on your machine.

---

## Option B: Install with pip (No Docker)

If you don't have Docker:

```bash
# Install
pip install open-webui

# Run
open-webui serve
```

Then open **http://localhost:8080**.

---

## What You'll See

After logging in, Open WebUI looks and feels like ChatGPT:

![Open WebUI Interface](https://github.com/open-webui/open-webui/raw/main/demo.png)

**Key areas:**

| Area | What It Does |
|:-----|:-------------|
| **Chat panel** (left) | Your conversation history |
| **Model selector** (top) | Switch between all your downloaded models |
| **Chat input** (bottom) | Type your message |
| **Paperclip icon** | Upload documents |
| **Settings gear** | Configure model parameters, RAG, voice |

---

## Cool Things to Try

### 1. Switch Models Mid-Chat

In the top dropdown, you can switch models during a conversation. Each model sees the same chat history.

- Start with `qwen2.5:7b` for general chat
- Switch to `deepseek-r1:14b` when you need hard reasoning
- Switch to `codellama` for code tasks

### 2. Upload Documents (Built-in RAG)

Click the paperclip icon and upload a PDF, Word doc, or text file. The model can then answer questions about it.

**Use cases:**
- Upload a research paper and ask questions
- Upload your company's handbook
- Upload a textbook chapter for study help

### 3. Use Voice Input

Click the microphone icon to speak instead of type. This works in Chrome and Edge.

### 4. Customize the Model's Behavior

In Settings → Model, you can adjust:
- **Temperature:** 0.2 (precise) to 1.0 (creative)
- **Context length:** How much the model remembers
- **System prompt:** The model's persona

---

## Advanced: Connecting to Other Services

### Image Generation

Open WebUI can integrate with local image generators:

```bash
# Add Automatic1111 (Stable Diffusion)
docker run -d \
  -p 7860:7860 \
  -v sd-models:/models \
  --gpus all \
  asd/stable-diffusion-webui:latest
```

Then configure in Open WebUI Settings → Image Generation.

### Web Search (Experimental)

Enable web search in Settings → Web Search. Open WebUI will search the internet when answering questions.

---

## Production Setup

### With HTTPS

For secure remote access (behind a VPN or tunnel):

```bash
# Using Caddy as a reverse proxy
docker run -d \
  -p 443:443 \
  -v open-webui:/app/backend/data \
  -e OLLAMA_BASE_URL=http://ollama:11434 \
  -e WEBUI_SECRET_KEY=your-secret-here \
  --name open-webui \
  ghcr.io/open-webui/open-webui:main
```

### Multi-User Setup

Open WebUI supports multiple users out of the box. Each user:
- Gets their own chat history
- Can't see other users' chats
- Can choose from any model you've pulled

To add users: Go to Settings → Admin Panel → Users → Create User.

---

## Troubleshooting

| Problem | Cause | Fix |
|:--------|:------|:----|
| "Connection refused" | Ollama not running | Start Ollama first: `ollama serve` |
| Blank page at localhost:3000 | Container not started | `docker start open-webui` |
| "No models available" | No models pulled | `ollama pull qwen2.5:7b` |
| Slow document Q&A | Embedding model not loaded | First doc upload takes extra time to load embeddings |
| Port 3000 already in use | Another service using it | Change port: `-p 8080:8080` and use `http://localhost:8080` |
| Container won't start | Docker not running | Start Docker Desktop or Docker daemon |

---

## Resources

- **Official docs:** [docs.openwebui.com](https://docs.openwebui.com)
- **GitHub:** [github.com/open-webui/open-webui](https://github.com/open-webui/open-webui)
- **Docker Hub:** [ghcr.io/open-webui/open-webui](https://ghcr.io/open-webui/open-webui)

---

> **Next step:** Now that you have a GUI, try setting up [Local RAG](./anythingllm-rag.md) — let your LLM answer questions about your own documents.
>
> *Part of the [Local LLM Guide](https://github.com/Lingdas1/local-llm-guide) — the definitive resource for running AI on your own hardware.*
