# Llama 4: Meta's Latest — Scout, Maverick, and the MoE Revolution

> **The open-source default just got a massive upgrade. Here's what's new and which variant you should actually use.**

## Llama 4 at a Glance

Meta released Llama 4 in April 2025 with a fundamental architecture change: **Mixture of Experts (MoE)**. Two variants were launched simultaneously:

| Variant | Architecture | Total Params | Active per Token | Min VRAM (Q4) |
|---------|-------------|:---:|:---:|:---:|
| **Llama 4 Scout** | 17B × 16 experts | 109B | ~17B | **10 GB** |
| **Llama 4 Maverick** | 17B × 128 experts | 2T | ~17B | **10 GB** |

Both are available on Ollama as `llama4:latest` (points to Scout) and `llama4:maverick`.

> 💡 **The story that sells itself:** Meta spent millions training a 2-trillion-parameter model and you can run it on a used gaming GPU. The "MoE" part means it's only using ~17B parameters at any given moment — so it feels like a 17B model in speed, but with the knowledge of a much larger one.

---

## Quick Start

```bash
# Scout (balanced — good default)
ollama pull llama4:latest

# Maverick (bigger knowledge, same speed)
ollama pull llama4:maverick
```

> ⚠️ **Verify before pulling:** Model names on Ollama change. Check `https://ollama.com/library/llama4` for current tags.

---

## Scout vs Maverick: Which One?

```
Your use case?
├── General chat, writing, everyday coding → Scout (llama4:latest)
├── Deep knowledge, fact-heavy tasks, research → Maverick (llama4:maverick)
├── Speed-critical, low VRAM → Scout
└── Both run at the same speed per token — the difference is knowledge breadth
```

**The practical difference:** Maverick has 128 experts vs Scout's 16. This means Maverick's "collective knowledge" is much broader — it's seen more patterns, more facts, more edge cases. But per-token speed is nearly identical because both only activate ~17B parameters at a time.

For most people: **start with Scout, upgrade to Maverick if you need more depth.**

---

## What Llama 4 Excels At

| Task | Rating | Notes |
|------|:---:|-------|
| General conversation | ⭐⭐⭐⭐⭐ | Natural, helpful, rarely hallucinates |
| Creative writing | ⭐⭐⭐⭐ | Good, but Claude-level models still edge it out |
| Coding | ⭐⭐⭐⭐ | Strong general coding, weaker at math-heavy tasks |
| Multilingual | ⭐⭐⭐⭐ | Supports 8 languages natively |
| Long context | ⭐⭐⭐ | 128K context works but quality degrades past 64K |

---

## The "But Meta Says I Can't Use It Commercially" Issue

This comes up constantly. **Here's the actual situation as of May 2026:**

- **Llama 4 is NOT the old "Llama 2 Community License"** — it's under the **Llama 4 Community License**, which is significantly more permissive
- **Commercial use is allowed** for companies under 700 million monthly active users
- **You can fine-tune and distribute** your fine-tuned versions
- **The license restricts** using Llama outputs to train competing models

For indie developers, startups, and small businesses: **you're free to use it commercially.** For FAANG-sized companies: you need a separate agreement with Meta.

> If you want truly unrestricted open-source, use DeepSeek-R1 (MIT) or Qwen (Apache 2.0).

---

## Real-World Benchmarks (Community-Tested)

On an RTX 4090 (24GB):

| Model (Q4_K_M) | tok/s | MMLU-Pro | HumanEval |
|---|---|---|---|
| Llama 4 Scout | ~45 | 68.2 | 76.8 |
| Llama 4 Maverick | ~42 | 72.1 | 79.3 |
| DeepSeek-R1 32B | ~22 | 74.5 | 84.1 |
| Qwen 3.6 32B | ~25 | 73.0 | 81.4 |

**Takeaway:** Llama 4 Scout/Maverick are the fastest high-quality models you can run locally. If speed matters more than raw benchmark scores, they're the pragmatic choice.

---

## Pro Tips

1. **Use `llama4:maverick` with a 32K context limit** — the full 128K eats VRAM and degrades attention quality
2. **Don't use Q2/Q3 quants** — MoE models lose coherence more sharply at extreme quantization than dense models
3. **Scout is the sweet spot for most setups** — unless you're doing research or fact-heavy work

---

**Related guides:** [Gemma 4](./gemma-4.md) | [Qwen](./qwen-guide.md) | [MoE Models](./moe-guide.md)
