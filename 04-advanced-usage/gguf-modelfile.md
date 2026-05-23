# GGUF & Modelfile: The Power User's Guide to Local LLMs

> **Beyond `ollama pull` — download any model from Hugging Face, quantize it, customize it, and import it into Ollama.**

## What's GGUF?

**GGUF** (GPT-Generated Unified Format) is the standard file format for running LLMs locally. Think of it as the `.mp3` of AI models:

- **Compressed** — 70-85% smaller than the original float16 weights
- **Fast** — optimized for CPU and GPU inference
- **Portable** — one file contains the entire model
- **Metadata-rich** — includes tokenizer, chat template, and model config

Every `ollama pull` downloads a GGUF file under the hood. But the real power move is downloading GGUF files directly from Hugging Face and importing them yourself.

### Quantization Analogy (Steal This)

> Quantization is like **JPEG compression for AI models**. A RAW photo is 50MB. A JPEG of the same photo is 5MB — 90% smaller, but it still looks 95% as good. That's what Q4_K_M quantization does to a model: 70% smaller, 96% of the intelligence.

---

## Step 1: Finding the Right GGUF File

### The Golden Rule

**Always look for `Q4_K_M`** — it's the sweet spot of size vs quality for almost every model.

### Where to Find GGUFs

| Source | URL | Best For |
|--------|:---:|:---------|
| **Official provider** | `huggingface.co/Qwen` etc. | Trustworthy, but often only Q8/Q6 |
| **Unsloth** | `huggingface.co/unsloth` | Best selection of quants (Q2-Q8) |
| **Bartowski** | `huggingface.co/bartowski` | Massive library, every quantization |
| **MaziyarPanahi** | `huggingface.co/MaziyarPanahi` | Merged models, niche architectures |

### The GGUF Filename Decoder

```
Qwen2.5-14B-Q4_K_M.gguf
├── Model name      ├── Size   └── Quantization
```

| Quant Code | Compression | Quality | Use Case |
|:----------:|:-----------:|:-------:|:---------|
| Q8_0 | 50% | 99% | When you have VRAM to spare |
| Q6_K | 60% | 98% | High-quality, reasonable size |
| **Q4_K_M** | **70%** | **96%** | **🟢 Sweet spot — use this** |
| Q3_K_M | 78% | 92% | When VRAM is tight |
| Q2_K | 85% | 85% | Emergency only — quality noticeably drops |
| IQ4_XS | 72% | 95% | Experimental import format |

---

## Step 2: Download & Import a GGUF

### Basic Import

```bash
# 1. Download Q4_K_M of Qwen 2.5-14B
wget https://huggingface.co/bartowski/Qwen2.5-14B-GGUF/resolve/main/Qwen2.5-14B-Q4_K_M.gguf

# 2. Create a Modelfile
cat > Modelfile << 'EOF'
FROM ./Qwen2.5-14B-Q4_K_M.gguf
EOF

# 3. Import into Ollama
ollama create my-custom-model -f Modelfile

# 4. Run it
ollama run my-custom-model
```

### Smart Import (with Optimized Settings)

```bash
cat > Modelfile << 'EOF'
FROM ./DeepSeek-R1-14B-Q4_K_M.gguf

# Performance tuning
PARAMETER num_ctx 32768
PARAMETER num_gpu_layers 999
PARAMETER num_thread 8
PARAMETER numa true

# Generation
PARAMETER temperature 0.7
PARAMETER top_p 0.9
PARAMETER repeat_penalty 1.1

# Chat template (CRITICAL — must match the model!)
TEMPLATE """{{ if .System }}<|im_start|>system
{{ .System }}<|im_end|>
{{ end }}<|im_start|>user
{{ .Prompt }}<|im_end|>
<|im_start|>assistant
"""

# System prompt
SYSTEM """You are a helpful AI assistant."""
EOF

ollama create my-r1-custom -f Modelfile
ollama run my-r1-custom
```

---

## Step 3: Modelfile Reference

A Modelfile is like a **Dockerfile for LLMs**. Every line is an instruction.

### Parameters Reference

| Parameter | What It Does | Default | Recommended Range |
|:----------|:-------------|:-------:|:-----------------:|
| `temperature` | Creativity level | 0.8 | 0.2 (code) – 1.0 (creative) |
| `top_p` | Nucleus sampling | 0.9 | 0.85 – 0.95 |
| `top_k` | Top-K sampling | 40 | 20 – 100 |
| `num_ctx` | Context window size | 2048 | 4096 – 65536 |
| `num_gpu` | GPU layers | 0 (auto) | 999 (use all VRAM) |
| `num_thread` | CPU threads | auto | 4 – 16 |
| `repeat_penalty` | Penalize repetition | 1.1 | 1.0 – 1.2 |
| `stop` | Stop sequences | varies | `<|im_end|>`, `\n\n` |

### INSTRUCTION vs SYSTEM vs TEMPLATE

```dockerfile
# SYSTEM: Persistent system prompt (like OpenAI's system message)
SYSTEM """You are a helpful assistant."""

# TEMPLATE: How user messages are formatted
TEMPLATE """User: {{ .Prompt }}
Assistant: """

# INSTRUCTION: Model-specific instruction format (rarely needed)
INSTRUCTION """Follow the user's instructions carefully."""
```

### Three Production Configs

**1. Coding Assistant**
```dockerfile
FROM qwen2.5:7b
PARAMETER temperature 0.2
PARAMETER top_p 0.85
PARAMETER num_ctx 65536
PARAMETER repeat_penalty 1.1
SYSTEM """You are an expert Python developer. Write clean, tested code."""
```

**2. Creative Writer**
```dockerfile
FROM mistral
PARAMETER temperature 1.0
PARAMETER top_p 0.95
PARAMETER num_ctx 16384
SYSTEM """You are a novelist. Be vivid and descriptive."""
```

**3. Customer Support**
```dockerfile
FROM llama4
PARAMETER temperature 0.5
PARAMETER top_p 0.9
PARAMETER num_ctx 8192
SYSTEM """You are a helpful customer support agent.
Be polite, concise, and solution-oriented.
NEVER mention that you are an AI."""
```

---

## Step 4: Advanced Techniques

### 4.1 Multi-GPU Setup

```dockerfile
FROM deepseek-r1:70b

# Distribute across 2 GPUs
PARAMETER num_gpu_layers 999
PARAMETER main_gpu 0
PARAMETER tensor_split "0.5,0.5"
```

### 4.2 LoRA Adapters (Experimental)

Some Ollama builds support LoRA adapters:

```dockerfile
FROM base-model
ADAPTER ./my-finetune-lora.gguf
PARAMETER temperature 0.7
```

### 4.3 Custom Stop Tokens

DeepSeek-R1 and Qwen use different stop tokens:

```dockerfile
# For Qwen
TEMPLATE """<|im_start|>user
{{ .Prompt }}<|im_end|>
<|im_start|>assistant
"""
PARAMETER stop "<|im_end|>"
PARAMETER stop "<|im_start|>"

# For DeepSeek
TEMPLATE """User: {{ .Prompt }}
Assistant: """
PARAMETER stop "User:"
```

### 4.4 Emergency: VRAM Too Low

If you get "CUDA out of memory":

```dockerfile
# Force CPU for some layers
PARAMETER num_gpu_layers 24  # Only put 24 layers on GPU
PARAMETER num_thread 8       # Use 8 CPU threads for the rest
```

---

## Step 5: GGUF from Ollama Models (Export)

You can also **export** a model from Ollama back to a GGUF file:

```bash
# Save a model as GGUF
ollama pull qwen2.5:7b
ollama export qwen2.5:7b ./my-export.gguf

# Now you can use it anywhere (llama.cpp, text-generation-webui, etc.)
./llama-cli -m ./my-export.gguf -p "Hello"
```

This is useful for:
- Moving models between machines without re-downloading
- Using the same model with multiple inference engines
- Sharing a specific quantization with teammates

---

## Performance Cheat Sheet

### By GPU

| GPU | VRAM | Best GGUF Model | Expected Speed |
|:---|:----:|:---------------:|:--------------:|
| RTX 3060 / 4060 | 12 GB | Qwen 2.5-14B (Q4_K_M) | 30-40 tok/s |
| RTX 4070 / 5070 | 12 GB | Qwen 2.5-14B (Q4_K_M) | 35-50 tok/s |
| RTX 4080 / 5080 | 16 GB | DeepSeek-R1-14B (Q4_K_M) | 30-45 tok/s |
| RTX 4090 / 5090 | 24 GB | DeepSeek-R1-32B (Q4_K_M) | 18-25 tok/s |
| Mac M2 Pro | 16 GB | Qwen 2.5-7B (Q4_K_M) | 15-25 tok/s |
| Mac M4 Max | 36 GB | Qwen 3.6-27B (Q4_K_M) | 20-30 tok/s |

### CPU-Only Performance

| Model | Quant | RAM | Speed |
|:-----|:-----:|:---:|:-----:|
| Qwen 2.5-1.5B | Q4_K_M | 4 GB | 8-15 tok/s |
| Qwen 2.5-7B | Q4_K_M | 16 GB | 1-4 tok/s |
| Qwen 2.5-7B | Q2_K | 8 GB | 2-6 tok/s |

---

## Common Pitfalls

| Problem | Cause | Fix |
|---------|-------|-----|
| "Model not found" after import | Modelfile path is wrong | Use absolute path: `FROM /home/user/model.gguf` |
| Gibberish output | Wrong chat template | The TEMPLATE line must match the model's expected format |
| Slow generation | Running on CPU | `PARAMETER num_gpu_layers 999` |
| CUDA out of memory | Quantization too large for VRAM | Try smaller quant (Q3_K_M instead of Q4_K_M) |
| Import errors | Corrupt GGUF download | Re-download and verify checksum |
| Temperature not working | Set in Modelfile but overridden in API | Use the same temp in both places |
| Chinese text output | Wrong template or default system prompt | Add `PARAMETER stop "<|im_end|>"` + English-only system prompt |

---

## The tl;dr

1. **Download:** `wget <huggingface-url>/Model-Q4_K_M.gguf`
2. **Create Modelfile:** `FROM ./Model.gguf` + your settings
3. **Import:** `ollama create my-model -f Modelfile`
4. **Run:** `ollama run my-model`
5. **Profit:** Free, private, local AI

---

*Part of the [Local LLM Guide](https://github.com/Lingdas1/local-llm-guide) — the definitive resource for running AI on your own hardware.*
