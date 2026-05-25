# MoE Models: The Architecture That Changed Everything

> **"Mixture of Experts" sounds complicated. Here's what it actually means for your GPU — and why it's the biggest local AI breakthrough since quantization.**

## What Is MoE? (The 30-Second Version)

A **dense** model activates every parameter for every token. A 70B dense model uses all 70 billion parameters on every single word.

A **Mixture of Experts (MoE)** model has many "expert" sub-networks, but only activates a few per token. A 109B MoE model might only use 17B parameters at any given moment.

```
Dense model (Llama 3 70B):
  Every token → ALL 70B parameters → 💸💸💸

MoE model (Llama 4 Scout 109B):
  Every token → Router picks 1-2 experts → Only 17B active → 🚀🚀🚀
```

> 💡 **The story:** You get the knowledge breadth of a massive model with the speed of a much smaller one. That's the MoE magic.

---

## MoE Models You Can Run Locally

| Model | Total Params | Active per Token | Ollama Pull | Min VRAM |
|-------|:---:|:---:|------|:---:|
| **Llama 4 Scout** | 109B | ~17B | `llama4:latest` | 10 GB |
| **Llama 4 Maverick** | 2T | ~17B | `llama4:maverick` | 10 GB |
| **DeepSeek-R1** | 671B | ~37B | `deepseek-r1` | 24 GB (32B Q4) |
| **GLM-4** | — | ~9B | `glm4:9b` | 6 GB |
| **Mixtral 8×7B** | 47B | ~13B | `mixtral:latest` | 24 GB |
| **Qwen 2.5 MoE** | — | — | `qwen2.5-moe` | 10 GB |

---

## Why MoE Matters for Local AI (3 Reasons)

### 1. You Get Big-Model Knowledge on Consumer Hardware

A Llama 4 Maverick has absorbed patterns from 2 trillion parameters of training. But when you run it, it's only computing ~17B — which fits on a 10GB GPU. That's the equivalent of reading a 1000-page encyclopedia and only needing to recall 20 relevant pages to answer any question.

### 2. Speed Without Sacrifice

On identical hardware, MoE models at Q4_K_M are typically **2-3× faster** than dense models with comparable benchmark scores. A MoE 109B model running at 45 tok/s beats a dense 70B model struggling at 15 tok/s — while matching or exceeding its quality.

### 3. The Router Learns Your Patterns

The "router" in an MoE model decides which experts to activate. Over repeated use with similar types of queries, the routing becomes more efficient — the model effectively "learns" which experts you need most.

---

## MoE Trade-offs (The Honest Part)

| Advantage | Disadvantage |
|:---|:---|
| Fast inference | **High VRAM to load** — even though only 17B is active, all 109B weights must be in memory |
| Big knowledge base | **Poor at extreme quantization** — Q2/Q3 quants degrade MoE coherence faster than dense models |
| Great for diverse tasks | **Router can "misroute"** — occasionally a token hits a less-relevant expert |
| Efficient per-token | **First token is slow** — loading all experts into VRAM takes time |

### The VRAM Reality

This is the most common MoE trap:

```
"I have 12GB VRAM, Llama 4 Scout only uses 17B active, I should be fine!"

Reality: You need enough VRAM to hold ALL 109B weights, even though
only 17B are active at once. With Q4 quantization, that's ~55GB of
weights that need to fit somewhere.

Solution: llama.cpp offloads as much as possible to GPU, rest to RAM.
          You need: GPU VRAM + system RAM > model size in VRAM.
          On 12GB VRAM + 32GB RAM → works, but slower than all-GPU.
```

---

## MoE vs Dense: Which Should You Choose?

```
Your situation?
├── 24GB GPU (RTX 4090/3090) + 32GB+ RAM
│   → MoE! Llama 4 Scout/Maverick or DeepSeek-R1 32B
│
├── 12-16GB GPU (RTX 4070/4060 Ti)
│   → Dense is safer. Qwen 2.5 14B or DeepSeek-R1 14B.
│   → Llama 4 Scout works with offloading, but slower.
│
├── 8GB GPU (RTX 4060/3060)
│   → Stick to dense. Gemma 4 12B or Qwen 2.5 7B.
│
└── No GPU, 16GB+ RAM only
    → Dense small models: Gemma 4 4B, Phi-4, Qwen 2.5 7B
```

---

## The Future: MoE Is the New Normal

In 2024, MoE was experimental. In 2025, it became mainstream (Llama 4, Mixtral, DeepSeek-V3). By 2026, **every major lab is shipping MoE architectures.** The efficiency gains are too large to ignore.

For local AI users, this means: **you'll continue getting access to models with massive knowledge bases that run on modest hardware.** The gap between "what big tech has" and "what you can run at home" is shrinking, and MoE is the biggest reason why.

---

**Related guides:** [Llama 4](./llama-4.md) | [DeepSeek-R1](./deepseek-r1.md) | [GLM-4](./glm-4.md)
