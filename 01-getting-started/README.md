# 01 — Getting Started: Run Your First Local LLM (5 Minutes)

> 🟢 **Beginner** — No experience needed. Just a computer and 5 minutes.

---

## What Is a Local LLM? (Plain English)

An **LLM** (Large Language Model) is the brain behind ChatGPT, Claude, and Gemini.

A **local LLM** runs that brain on **your own computer** — not on someone else's server.

**Why does that matter?**

| Cloud AI (ChatGPT, Claude) | Local AI (Ollama + models) |
|:---|:---|
| $20–$200/month subscription | **$0** — completely free |
| Your data is sent to their servers | **Private** — everything stays on your machine |
| Requires internet | **Works offline** |
| Censored, filtered, rate-limited | **No limits** — you control everything |
| One-size-fits-all model | **Choose any model** for any task |

> 💡 **Think of it this way:** Cloud AI is like renting a car. Local AI is like owning a bicycle. The bicycle is slower, but it's yours, it's free, and nobody can take it away from you.

---

## What You Need

**Minimum requirements:**
- A computer (Windows, macOS, or Linux)
- At least 8 GB of RAM (16 GB recommended)
- A few GB of free disk space

**Nice to have (but not required):**
- A GPU with 4+ GB VRAM (models run faster, but CPU is fine to start)

> **My setup:** I'm running this on a [your hardware] with [your specs]. If it works for me, it'll work for you.

---

## Step 1: Install Ollama

Ollama is the easiest way to run local LLMs. Think of it as the "App Store for AI models."

### macOS

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

### Linux

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

### Windows

Download the installer from [ollama.com/download](https://ollama.com/download) and run it.

### Verify Installation

Open a new terminal and type:

```bash
ollama --version
```

You should see something like:
```
ollama version 0.6.0
```

> 🔥 **Pro tip:** If you get "command not found" on Linux/macOS, restart your terminal or run: `export PATH=$PATH:/usr/local/bin`

---

## Step 2: Pull Your First Model

Now for the fun part — downloading an actual AI brain to run on your computer.

```bash
ollama pull qwen2.5:7b
```

This downloads a 4.7 GB model. On a typical internet connection, it takes 2–5 minutes.

**While it downloads, here's what's happening:**
- Ollama is downloading a **GGUF file** (the compressed model format)
- It's auto-detecting your GPU
- It's setting up the inference engine

**What if the download is too big?** Try a smaller model:

```bash
# For 8 GB RAM laptops — works on almost anything
ollama pull qwen2.5:1.5b

# For 4 GB RAM or very old computers
ollama pull qwen2.5:0.5b
```

---

## Step 3: Chat With Your Model

```bash
ollama run qwen2.5:7b
```

You'll see a prompt like `>>>`. Type something:

```
>>> Write a haiku about a cat sitting on a computer
```

The model will think for a moment and then respond. **Congratulations — you just ran an AI on your own hardware!** 🎉

### Try These First Commands

```
>>> Write a Python function to calculate fibonacci

>>> Explain quantum computing like I'm 10

>>> What's the meaning of life?

>>> /? -- show all available commands

>>> /exit -- quit the chat
```

> ⚠️ **Expect it to be slower than ChatGPT.** That's normal! Local models run at 15–40 tokens per second on a GPU, or 2–6 tok/s on CPU. It's still faster than most people read.

---

## Step 4: Choose the Right Model for Your Hardware

**Not sure which model to pick? Use this decision tree:**

```
Your GPU VRAM?
├── No GPU (CPU only)
│   ├── 32 GB RAM → qwen2.5:7b (slow but works)
│   ├── 16 GB RAM → qwen2.5:1.5b
│   └── 8 GB RAM  → qwen2.5:0.5b
├── 4–6 GB VRAM   → qwen2.5:7b
├── 8–12 GB VRAM  → deepseek-r1:14b (🟢 BEST for most people)
├── 12–16 GB VRAM → deepseek-r1:32b
├── 24 GB VRAM    → qwen3.6:27b or deepseek-r1:32b (Q4)
└── 36+ GB VRAM   → deepseek-r1:70b or qwen2.5:72b
```

### Model Comparison Table

| Model | Ollama Command | Size (Disk) | Min RAM | Min VRAM | Quality |
|:-----|:---------------|:-----------:|:-------:|:--------:|:-------:|
| Qwen 2.5:0.5B | `ollama pull qwen2.5:0.5b` | 0.5 GB | 4 GB | None | Basic text |
| Qwen 2.5:1.5B | `ollama pull qwen2.5:1.5b` | 1.1 GB | 8 GB | None | Simple tasks |
| **Qwen 2.5:7B** | **`ollama pull qwen2.5:7b`** | **4.7 GB** | **8 GB** | **4 GB** | **🟢 Good start** |
| Qwen 2.5:14B | `ollama pull qwen2.5:14b` | 9.0 GB | 16 GB | 8 GB | Excellent |
| DeepSeek-R1:14B | `ollama pull deepseek-r1:14b` | 8.2 GB | 16 GB | 8 GB | 🏆 Best value |
| DeepSeek-R1:32B | `ollama pull deepseek-r1:32b` | 18.7 GB | 32 GB | 16 GB | Near o1 level |
| Qwen 3.6:27B | `ollama pull qwen3.6:27b` | 15 GB | 32 GB | 16 GB | Cutting-edge |
| Llama 4:8B | `ollama pull llama4` | 4.9 GB | 8 GB | 4 GB | Good general |

> **My recommendation for first-timers:** Start with `qwen2.5:7b`. It runs on almost anything, and it's good enough to be genuinely useful.

---

## What to Do After Your First Chat

You've run your first local LLM. Now what?

**Next steps in order:**

| # | Task | Why | Guide |
|:--|:-----|:----|:------|
| 1 | **Customize your model** with a Modelfile | Control temperature, context length, and behavior | [GGUF & Modelfile Guide](../04-advanced-usage/gguf-modelfile.md) |
| 2 | **Install Open WebUI** | Get a ChatGPT-like web interface instead of the terminal | [Open WebUI Setup](../04-advanced-usage/open-webui-setup.md) |
| 3 | **Benchmark your hardware** | See what speeds your setup can achieve | Script: `./scripts/ollama-benchmark.sh` |
| 4 | **Add document search (RAG)** | Let your LLM answer questions about your own files | [RAG Guide](../04-advanced-usage/anythingllm-rag.md) |
| 5 | **Try a reasoning model** | Switch to DeepSeek-R1 for harder problems | [DeepSeek-R1 Guide](../03-models/deepseek-r1.md) |

---

## Common First-Timer Problems (And Fixes)

| Problem | Why | Fix |
|:--------|:----|:----|
| "ollama: command not found" | Ollama not in PATH | Restart terminal, or run: `export PATH=$PATH:/usr/local/bin` |
| Download is very slow | Big file on slow internet | Try `ollama pull qwen2.5:1.5b` instead (much smaller) |
| Model responds very slowly | Running on CPU | This is normal! See speed expectations in the table above |
| Model responds in Chinese | Default template includes Chinese | Add `SYSTEM "Always respond in English."` to a Modelfile |
| "CUDA out of memory" | Model too big for your GPU | Use a smaller model or lower quantization |
| "Connection refused" | Ollama server not running | Run `ollama serve` in a separate terminal first |

---

## Quick Reference: Common Ollama Commands

```bash
# List all downloaded models
ollama list

# Show currently running models
ollama ps

# Delete a model to free space
ollama rm qwen2.5:7b

# Update a model to the latest version
ollama pull qwen2.5:7b

# Run a model with a one-shot prompt (non-interactive)
ollama run qwen2.5:7b "Write a Python script to download images from a URL"

# Use the API (OpenAI compatible)
curl http://localhost:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model": "qwen2.5:7b", "messages": [{"role": "user", "content": "Hello!"}]}'
```

---

## Your First Week Plan

| Day | Task | Time |
|:---|:-----|:----:|
| **Day 1** | Install Ollama + pull a model + chat with it | 5 minutes ✅ |
| **Day 2** | Try different models (small vs large) | 15 minutes |
| **Day 3** | Customize with a Modelfile | 30 minutes |
| **Day 4** | Install Open WebUI | 30 minutes |
| **Day 5** | Ask your LLM to write code or help with real work | 1 hour |
| **Weekend** | Try RAG — let your LLM read your documents | 1 hour |

---

> 🎯 **You've taken the first step.** Running a local LLM is like learning to ride a bike — wobbly at first, but once you get it, you'll wonder why you didn't start sooner.
>
> **Found this helpful?** [⭐ Star the repo](https://github.com/Lingdas1/local-llm-guide) — it helps others find it too.
>
> *— Ling, a medical student who accidentally fell into AI and wants to help you do the same.*
