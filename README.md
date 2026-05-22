# 🦙 Local LLM Guide

> **The definitive, beginner-friendly guide to running Large Language Models on your own hardware.**

[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen)](CONTRIBUTING.md)

Covers **Ollama**, **GGUF**, **Open WebUI**, **DeepSeek-R1**, **Qwen 2.5**, **GLM-4**, and everything you need to go from zero to a fully functional local AI stack — **without paying a dime in API fees**.

---

## 📝 Latest Blog Post

> **[The Complete Guide to Running LLMs Locally in 2026: From Ollama to Production](./blog/complete-guide-local-llm-2026.md)**
>
> The definitive beginner-friendly guide covering hardware, Ollama setup, Chinese models, GGUF quantization, Open WebUI, and local RAG.

---

## ✨ Why This Guide?

Most AI tutorials assume you have:
- 🚀 Unlimited OpenAI API budget
- 💻 A server with 8× A100 GPUs
- 🧠 Deep understanding of ML internals

**Real life is different.** You have a gaming PC, a MacBook, or a Linux server with a consumer GPU. You want privacy. You want to avoid API costs. You want to run open-source models that are **as good as GPT-4o** — like DeepSeek-R1 or Qwen 2.5 — on your own hardware.

**This guide is for you.**

---

## 📖 Table of Contents

| # | Chapter | Topic | Level |
|---|---|---|---|
| 01 | [Getting Started](./01-getting-started/) | Install Ollama, run your first model | 🟢 Beginner |
| 02 | [Hardware Guide](./02-hardware-guide/) | GPU/CPU/RAM requirements, matching matrix | 🟢 Beginner |
|| 03 | [Model Guides](./03-models/) | DeepSeek-R1, Qwen 2.5, GLM-4, Llama 4, Gemma 4 | 🟡 Intermediate |
| 04 | [Advanced Usage](./04-advanced-usage/) | GGUF from HF, Modelfile, Open WebUI, RAG | 🟡 Intermediate |
| 05 | [Production](./05-production/) | Multi-user, API deployment, Docker, monitoring | 🔴 Advanced |
| 06 | [Function Calling](./06-function-calling/) | Tool use with local models, LangChain integration | 🔴 Advanced |

---

## 🚀 Quick Start (5 minutes)

```bash
# 1. Install Ollama (macOS / Linux)
curl -fsSL https://ollama.com/install.sh | sh

# 2. Windows: Download from https://ollama.com/download

# 3. Pull your first model
ollama pull qwen2.5:7b

# 4. Run it
ollama run qwen2.5:7b
```

> 💡 **New to local LLMs?** Start with [Chapter 1: Getting Started](./01-getting-started/).

---

## 🗺️ Hardware Quick Reference

| Your GPU | VRAM | Best Models | Quantization | Expected Speed |
|---|---|---|---|---|
| RTX 3060 | 12 GB | Qwen 2.5:7b, DeepSeek-R1:14b | Q4_K_M | 25-35 tok/s |
| RTX 4070 | 12 GB | Qwen 2.5:14b, DeepSeek-R1:14b | Q4_K_M | 35-50 tok/s |
| RTX 4090 | 24 GB | Qwen 2.5:32b, DeepSeek-R1:32b | Q4_K_M | 20-30 tok/s |
| Mac M1/M2 | 8-16 GB | Qwen 2.5:7b, Gemma 4:9b | Q4_K_M | 15-25 tok/s |
| Mac M3/M4 | 18-48 GB | Qwen 2.5:14b, DeepSeek-R1:14b | Q4_K_M | 25-45 tok/s |
| CPU only | 32 GB RAM | Qwen 2.5:7b, DeepSeek-R1:14b (CPU) | Q4_K_M | 1-4 tok/s |

> 📊 **Full hardware matrix →** [Chapter 2: Hardware Guide](./02-hardware-guide/gpu-requirements-matrix.md)

---

## 🧠 Why Chinese Models?

This guide has **unusually deep coverage** of Chinese open-source models (DeepSeek, Qwen, GLM). Here's why:

| Model | Key Strength | English Support | Best For |
|---|---|---|---|
| **DeepSeek-R1** | MoE architecture, SOTA reasoning | ⭐⭐⭐⭐⭐ | Coding, math, complex reasoning |
| **Qwen 2.5** | Best all-rounder, 128K context | ⭐⭐⭐⭐⭐ | Chat, RAG, vision tasks |
| **GLM-4** | Strong tool use & function calling | ⭐⭐⭐⭐ | Agentic workflows |

These models consistently **outperform Western models of the same size** on benchmarks, yet have **almost zero English documentation**. This guide fixes that.

---

## 🛠️ Included Scripts

| Script | What it does |
|---|---|
| [`hardware-check.sh`](./scripts/hardware-check.sh) | Detects GPU model, VRAM, RAM, and recommends best models |
| [`ollama-benchmark.sh`](./scripts/ollama-benchmark.sh) | Runs standardized benchmarks across models |
| [`modelfile-generator.sh`](./scripts/modelfile-generator.sh) | Interactive tool to create custom Modelfiles |
| [`docker-compose.yml`](./scripts/docker-compose.yml) | One-command deploy: Ollama + Open WebUI |

---

## 📝 License

MIT — free to use, fork, and share.

---

## 🤝 Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md). PRs welcome, especially:
- Hardware benchmark results from GPUs not listed
- Translation to other languages
- New model deployment guides

---

## ⭐ Support

- ⭐ Star this repo if you find it useful
- 💬 Join the discussion on [r/LocalLLaMA](https://reddit.com/r/LocalLLaMA)
- 🐛 Report issues [here](https://github.com/Lingdas1/local-llm-guide/issues)
