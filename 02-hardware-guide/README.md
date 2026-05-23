# 02 — Hardware Guide: What Do You Actually Need?

> 🟢 **Beginner** — No matter what computer you have, there's a model that will run on it.

---

## The Most Important Thing to Know

**VRAM is the bottleneck, not compute.**

A model running on a 5-year-old RTX 3060 at Q4 quantization gives you **96% of the quality** of the same model on an A100 — just slower. And "slower" for most use cases (chat, coding, document analysis) still means **20-40 tokens per second**, which is faster than most people read.

> 💡 **Analogy:** Running AI locally is like cooking at home vs. going to a Michelin-star restaurant. The restaurant (cloud AI) is faster and fancier. But your home cooking (local AI) is free, private, and tastes just as good — just takes a bit longer.

---

## The Quick Decision Tree

```
What computer do you have?
├── Gaming PC / Workstation with NVIDIA GPU
│   ├── 24 GB VRAM (RTX 4090/5090, RTX 3090) → deepseek-r1:32b or qwen3.6:27b
│   ├── 12-16 GB VRAM (RTX 4070/5070, RTX 4080) → qwen2.5:14b or deepseek-r1:14b  🟢
│   └── 8-12 GB VRAM (RTX 3060/4060) → qwen2.5:7b or deepseek-r1:7b
├── Mac
│   ├── 36 GB+ unified (M4 Max, M3 Max) → qwen3.6:27b or deepseek-r1:32b
│   └── 16 GB unified (M1/M2/M3) → qwen2.5:7b or phi-4:14b
├── AMD GPU
│   ├── 16 GB+ VRAM (RX 7900 XTX) → qwen2.5:14b
│   └── 8-12 GB VRAM (RX 7600/7700) → qwen2.5:7b
├── Intel Arc GPU → qwen2.5:7b (experimental support)
├── CPU only, 32 GB+ RAM → qwen2.5:7b (1-4 tok/s)
├── CPU only, 16 GB RAM → qwen2.5:1.5b (5-10 tok/s)
└── CPU only, 8 GB RAM → qwen2.5:0.5b (10-15 tok/s)
```

---

## GPU Comparison Table

| GPU | VRAM | Architecture | Best Model | Speed (tok/s) | Used Price |
|:----|:----:|:-----------:|:-----------|:-------------:|:----------:|
| **RTX 3060** 12GB | 12 GB | Ampere | Qwen 2.5:14B (Q4) | 25-35 | ~$200 |
| **RTX 4060** 8GB | 8 GB | Ada Lovelace | Qwen 2.5:7B (Q4) | 35-50 | ~$280 |
| **RTX 4060 Ti** 16GB | 16 GB | Ada Lovelace | DeepSeek-R1:14B (Q4) | 30-45 | ~$400 |
| **RTX 4070** 12GB | 12 GB | Ada Lovelace | Qwen 2.5:14B (Q4) | 40-55 | ~$500 |
| **RTX 4070 Ti** 16GB | 16 GB | Ada Lovelace | DeepSeek-R1:14B (Q4) | 35-50 | ~$650 |
| **RTX 4080** 16GB | 16 GB | Ada Lovelace | DeepSeek-R1:32B (Q4) | 20-30 | ~$800 |
| **RTX 4090** 24GB | 24 GB | Ada Lovelace | DeepSeek-R1:32B (Q3)/Qwen 3.6:27B | 25-35 | ~$1,500 |
| **RTX 5090** 32GB | 32 GB | Blackwell | DeepSeek-R1:70B (Q3) | 18-25 | ~$2,000 |
| **RTX 3090** 24GB | 24 GB | Ampere | DeepSeek-R1:32B (Q3)/Qwen 3.6:27B | 15-25 | ~$700 🟢 |
| **RTX 3080** 10/12GB | 10/12 GB | Ampere | Qwen 2.5:14B (Q4) | 20-30 | ~$350 |
| **RX 7900 XTX** 24GB | 24 GB | RDNA 3 | Qwen 3.6:27B | 20-30 | ~$800 |
| **RX 7800 XT** 16GB | 16 GB | RDNA 3 | DeepSeek-R1:14B (Q4) | 25-35 | ~$450 |
| **Arc A770** 16GB | 16 GB | Alchemist | Qwen 2.5:14B (Q4) | 15-25 | ~$250 |

> 🟢 **Best value picks:** Used RTX 3090 ($700 for 24 GB VRAM) or used RTX 3060 12GB ($200 for a starter).

---

## Model × VRAM Compatibility Matrix

| Model | Q8 (Full Quality) | Q6_K | Q4_K_M 🟢 | Q3_K_M | Q2_K |
|:-----|:-----------------:|:----:|:---------:|:------:|:----:|
| Qwen 2.5:0.5B | 0.7 GB | 0.5 GB | 0.4 GB | 0.3 GB | 0.2 GB |
| Qwen 2.5:1.5B | 1.9 GB | 1.5 GB | 1.1 GB | 0.9 GB | 0.7 GB |
| Qwen 2.5:7B | 8.1 GB | 6.3 GB | **4.7 GB** | 3.8 GB | 2.9 GB |
| Qwen 2.5:14B | 15.5 GB | 12.1 GB | **9.0 GB** | 7.2 GB | 5.4 GB |
| DeepSeek-R1:7B | 8.1 GB | 6.3 GB | **4.7 GB** | 3.8 GB | 2.9 GB |
| DeepSeek-R1:14B | 14.7 GB | 11.2 GB | **8.2 GB** | 6.4 GB | 4.9 GB |
| DeepSeek-R1:32B | 33.6 GB | 25.4 GB | **18.7 GB** | 14.5 GB | 10.8 GB |
| DeepSeek-R1:70B | 72.0 GB | 55.0 GB | **40.0 GB** | 31.0 GB | 23.0 GB |
| Qwen 3.6:27B | 30.0 GB | 23.0 GB | **15.0 GB** | 11.5 GB | 8.5 GB |
| Llama 4:8B | 9.0 GB | 7.0 GB | **4.9 GB** | 3.8 GB | 2.8 GB |
| GPT-OSS:20B | 22.0 GB | 17.0 GB | **11.5 GB** | 8.5 GB | 6.5 GB |

> **How to read this table:** Find your VRAM in the first section, then look across the Q4_K_M column to see which models fit. For example, with 12 GB VRAM, Qwen 2.5:14B (Q4_K_M = 9.0 GB) fits comfortably.

---

## Budget Builds

### The "Get Started" Build — $0 (Use What You Have)

If you already have a computer, you can probably run something:

| Your Current PC | Best Free Option | Can It Be Useful? |
|:---------------|:-----------------|:-----------------:|
| Any laptop with 8 GB RAM | Qwen 2.5:1.5B | ✅ Basic Q&A, simple tasks |
| Any laptop with 16 GB RAM | Qwen 2.5:7B (CPU mode) | ✅ ✅ Writing, brainstorming |
| Old gaming PC with GTX 1060 | Qwen 2.5:7B (GPU accel) | ✅ ✅ ✅ Coding, summarization |
| MacBook M1 with 8 GB | Qwen 2.5:1.5B | ✅ Basic assistance |

**Cost: $0.** You already own it. Just install Ollama.

### The "Best Bang for Buck" Build — ~$700

```
Used RTX 3090 (24 GB VRAM)  → $700
Rest of PC (keep what you have)
Total: ~$700
```

**What you can run with this:**
- DeepSeek-R1:32B (Q4_K_M) — o1-level reasoning
- Qwen 3.6:27B — latest cutting-edge
- Any 7B-14B model at full quality

**APIs this replaces:** ChatGPT Pro ($200/mo) + Claude Pro ($20/mo) = **break-even in ~3 months**

### The "Serious" Build — ~$2,500

```
New RTX 5090 (32 GB VRAM)    → $2,000
64 GB DDR5 RAM                → $200
1 TB NVMe SSD                 → $80
Rest is your existing PC
Total: ~$2,500
```

**What you can run:** DeepSeek-R1:70B, Qwen 2.5:72B, multiple models at once

---

## CPU-Only Guide

No GPU? No problem. You can still run local LLMs — just slower.

### What to Expect

| CPU | RAM | Best Model | Expected Speed | Readable? |
|:----|:---:|:-----------|:--------------:|:---------:|
| Modern i5/i7 (2020+) | 32 GB | Qwen 2.5:7B | 2-6 tok/s | ✅ Yes, like reading speed |
| Modern i5/i7 (2020+) | 16 GB | Qwen 2.5:1.5B | 5-10 tok/s | ✅ Comfortable |
| Older i5 (2017+) | 16 GB | Qwen 2.5:1.5B | 3-6 tok/s | ✅ Yes |
| Laptop (any) | 8 GB | Qwen 2.5:0.5B | 8-15 tok/s | ✅ Fast enough |

> **2-6 tok/s** means a 100-word paragraph takes 15-30 seconds to generate. It's slow by GPU standards but perfectly usable for getting answers.

### Tips for CPU Users

1. **Use smaller models:** Qwen 2.5:1.5B is surprisingly capable and runs well on any CPU
2. **Close other apps:** Free up RAM for the model
3. **Use Q2_K quantization:** Smaller but still useful
4. **Try llama.cpp directly:** Sometimes faster than Ollama on CPU

---

## RAM & VRAM Deep Dive

### How much RAM do you need?

| Usage | Minimum RAM | Recommended RAM |
|:------|:-----------:|:---------------:|
| CPU-only with small models (1.5B) | 8 GB | 16 GB |
| CPU-only with medium models (7B) | 16 GB | 32 GB |
| GPU offloading + OS + browser | 16 GB | 32 GB |
| Running multiple models | 32 GB | 64 GB |
| Production server | 32 GB | 64 GB |

### How VRAM is actually used

When you run a model, VRAM is consumed by:

1. **Model weights** (the biggest chunk — see the matrix above)
2. **KV Cache** (~1 GB per 8K tokens of context)
3. **Compute buffers** (~0.5 GB)
4. **Other apps** (your OS, browser, etc.)

**Rule of thumb:** Pick a model whose Q4_K_M size is at least 2 GB less than your total VRAM. The extra headroom handles the KV cache.

---

## Mac Users: Special Considerations

Apple Silicon Macs are surprisingly good for local LLMs because of **unified memory** — the GPU can access all system RAM.

| Mac Model | Unified Memory | Best Model | Notes |
|:----------|:--------------:|:-----------|:------|
| M1 MacBook Air | 8 GB | Qwen 2.5:1.5B | Surprising quality from small model |
| M1/M2 MacBook Pro | 16 GB | Qwen 2.5:7B | Sweet spot for Mac users |
| M3 Pro/Max | 36 GB | Qwen 3.6:27B | Top-tier performance |
| M4 Max | 48-128 GB | DeepSeek-R1:70B | Ultimate local AI machine |
| Mac Studio M4 Ultra | 128-256 GB | Run anything | Absolute beast |

**Pro tip:** Macs with MLX (Apple's ML framework) can run models faster than Ollama's default backend. Try:
```bash
# Install Ollama with MLX support
ollama pull qwen2.5:7b
# For MLX-native, try mlx-lm instead
pip install mlx-lm
mlx_lm.generate --model qwen2.5:7b --prompt "Hello"
```

---

## AMD & Intel GPU Users

### AMD (ROCm support)

```bash
# Install Ollama with ROCm
curl -fsSL https://ollama.com/install.sh | OLLAMA_ROCM=1 sh

# Verify GPU detection
ollama run qwen2.5:7b
# Should show "GPU = 1" in startup
```

**Known quirks:**
- RX 6000 series works well
- RX 7000 series needs ROCm 6.0+
- Integrated AMD GPUs (like in laptops) are not supported
- Performance is about 80-90% of equivalent NVIDIA

### Intel Arc

```bash
# Intel Arc support was added in Ollama 0.22+
# Check your version first
ollama --version

# If 0.22+, just pull and run
ollama run qwen2.5:7b
```

**Known quirks:**
- Arc A770 16GB is a surprisingly good budget option (~$250 used)
- Arc A580/A750 have limited support
- Expect 60-70% of NVIDIA performance
- Some models may fail on first load (retry usually works)

---

## The "I Just Want to Buy Something" Recommendation

| Budget | Buy This | Why |
|:------|:---------|:----|
| **$200** | Used RTX 3060 12GB | Best cheap entry point |
| **$700** | Used RTX 3090 24GB | Best value for serious local AI |
| **$2,000** | New RTX 5090 32GB | Best new card for AI (2026) |
| **$4,000+** | Mac Studio M4 Ultra | If you also do video/audio work |

---

## Quick Reference Card

```bash
# Check your GPU (Linux)
nvidia-smi
# Look for: "Memory-Usage: 4096MiB / 12288MiB" — the second number is your VRAM

# Check your GPU (macOS)
system_profiler SPDisplaysDataType | grep VRAM

# Check your RAM (Linux)
free -h

# Check your RAM (macOS)
system_profiler SPHardwareDataType | grep Memory

# See if Ollama detected your GPU
ollama run qwen2.5:7b --verbose 2>&1 | grep -i gpu
```

---

> **Bottom line:** Don't overthink hardware. Download Ollama, try `qwen2.5:1.5b` or `qwen2.5:7b`, and see how it feels. You can always upgrade later.
>
> *Part of the [Local LLM Guide](https://github.com/Lingdas1/local-llm-guide) — the definitive resource for running AI on your own hardware.*
