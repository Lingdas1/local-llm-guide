# 🦙 Local LLM Guide

> **The definitive, beginner-friendly guide to running Large Language Models on your own hardware.**

> 💡 *"在你认为对的方向先动起来就不会焦虑，但也要时不时停下来看看我们是否走在正确的方向。因为一个停止的表，一天走完至少它有两次是走对的；但一个走错了的表，哪怕走完一整天也是走错的。"*

[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen)](CONTRIBUTING.md)
[![Dev.to](https://img.shields.io/badge/read%20on-dev.to-0A0A0A)](https://dev.to/lingdas1)

---

## 👋 Pick Your Path

**One brand, two entry points.** Choose the one that fits you best:

| 👨‍💻 **For Developers** | 🧑‍🏫 **New to AI? Start Here** |
|:---|:---|
| You write code, you have a GPU (or want one), you want to **run AI locally** without API fees. | You've heard about AI but feel overwhelmed. You have a regular laptop and want to **understand what's possible**. |
| → [Start with the technical series](#-table-of-contents) | → [Beginner guides (plain English)](./blog/beginners/) |
| Also on [Dev.to](https://dev.to/lingdas1) | Also on [Dev.to](https://dev.to/lingdas1) |

---

## 📝 Latest

> **[Read the full series on Dev.to →](https://dev.to/lingdas1/local-llm-guide-the-complete-series-find-your-starting-point-4do5)**
> 9 articles covering everything from first setup to production deployment.

---

## ✨ Why This Guide?

Most AI tutorials assume you have:
- 🚀 Unlimited OpenAI API budget
- 💻 A server with 8× A100 GPUs
- 🧠 Deep understanding of ML internals

**Real life is different.** You have a gaming PC, a MacBook, or a Linux server with a consumer GPU. You want privacy. You want to avoid API costs. You want to run open-source models that are **as good as GPT-4o** — like DeepSeek-R1 or Qwen 2.5 — on your own hardware.

**This guide is for you.**

I'm a medical student, not a software engineer. If I can figure this out, so can you.

---

## 📖 Table of Contents

| # | Chapter | Topic | Level | Dev.to |
|:---:|---|:---|:---:|:---:|
| 01 | [Getting Started](./01-getting-started/) | Install Ollama, run your first model | 🟢 Beginner | [Read](https://dev.to/lingdas1/getting-started-run-your-first-local-llm-in-5-minutes-2i1j) |
| 02 | [Hardware Guide](./02-hardware-guide/) | GPU/CPU/RAM requirements, matching matrix | 🟢 Beginner | [Read](https://dev.to/lingdas1/hardware-guide-what-do-you-actually-need-to-run-local-llms-1eik) |
| 03 | [Model Guides](./03-models/) | DeepSeek-R1, Qwen 2.5, GLM-4, Llama 4, Gemma 4 | 🟡 Intermediate | [DeepSeek](https://dev.to/lingdas1/deepseek-r1-the-0-o1-alternative-you-can-run-right-now-24a5) · [Qwen](https://dev.to/lingdas1/qwen-36-25-the-most-versatile-local-models-1d8e) |
| 04 | [Advanced Usage](./04-advanced-usage/) | GGUF from HF, Modelfile, Open WebUI, RAG | 🟡 Intermediate | [GGUF](https://dev.to/lingdas1/gguf-modelfile-the-power-users-guide-to-local-llms-1fbi) · [WebUI](https://dev.to/lingdas1/open-webui-your-local-chatgpt-29d8) · [RAG](https://dev.to/lingdas1/local-rag-chat-with-your-documents-open-source-private-390o) |
| 05 | [Production](./05-production/) | Multi-user, API deployment, Docker, monitoring | 🔴 Advanced | [Read](https://dev.to/lingdas1/production-ready-local-llms-from-terminal-to-team-deployment-4ph2) |
| 06 | [Function Calling](./06-function-calling/) | Tool use with local models, LangChain integration | 🔴 Advanced | [Read](https://dev.to/lingdas1/function-calling-for-local-llms-deepseek-qwen-glm-4-langchain-4iac) |

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

> 📊 **Full hardware matrix →** [Chapter 2: Hardware Guide](./02-hardware-guide/)

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

- ⭐ Star this repo if you find it useful — you'll get notified when new chapters drop
- 📖 Read the full series on [Dev.to](https://dev.to/lingdas1)
- 💬 Join the discussion on [r/LocalLLaMA](https://reddit.com/r/LocalLLaMA)
- 🐛 Report issues [here](https://github.com/Lingdas1/local-llm-guide/issues)
