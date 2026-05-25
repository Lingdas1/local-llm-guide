# 03 — Model Guides

> 🟡 Intermediate — Detailed guides for running specific models locally.

**New to local models?** Start with [Llama 4](./llama-4.md) (best all-rounder) or [Qwen](./qwen-guide.md) (strongest overall).

## Contents

| Model | Ollama Name | Size Range | Best For | Min VRAM |
|---|---|---|---|---|
| [DeepSeek-R1](./deepseek-r1.md) | `deepseek-r1` | 14B ~ 671B | Coding, math, o1-level reasoning | 8 GB (14B Q4) |
| [Qwen 2.5 / 3.6](./qwen-guide.md) | `qwen2.5` / `qwen3.6` | 0.5B ~ 72B | Best all-rounder, 262K context | 4 GB (7B Q4) |
| [Llama 4](./llama-4.md) | `llama4` | Scout (109B) / Maverick (2T) | General purpose (Meta), MoE speed | 10 GB (Q4, with offload) |
| [Gemma 4](./gemma-4.md) | `gemma4` | 2B ~ 31B | Lightweight, laptops, edge devices | 1.5 GB (2B Q4) |
| [GLM-4](./glm-4.md) | `glm4` | 9B | Bilingual (EN+ZH), agent workflows | 6 GB (9B Q4) |
| [MoE Models Guide](./moe-guide.md) | — | — | Understanding Mixture of Experts architecture | — |

## Which Model Should You Pick?

```
What's your priority?
├── Coding / math / reasoning → DeepSeek-R1
├── Best all-rounder → Qwen 2.5 / 3.6
├── Speed + fast inference → Llama 4 (MoE)
├── Limited hardware / laptop → Gemma 4
├── Bilingual (Chinese + English) → GLM-4
└── Don't know → Start with Qwen 7B or Llama 4 Scout
```

## Key Concepts

- **Quantization (Q4/Q5/Q8):** Compression that reduces VRAM usage. Q4 = 4-bit, good enough for most tasks. Q8 = 8-bit, higher quality but double the VRAM.
- **MoE (Mixture of Experts):** Architecture where only a fraction of model parameters activate per token — big knowledge, small compute. [Full guide →](./moe-guide.md)
- **GGUF:** File format for running models locally via llama.cpp / Ollama. [See 04-Advanced →](../04-advanced-usage/gguf-modelfile.md)
- **Context Window:** How much text the model can "see" at once. Longer = better for documents, but costs more VRAM.
