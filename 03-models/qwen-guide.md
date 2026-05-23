# Qwen 3.6 & 2.5: The Most Versatile Local Models

> **The best all-rounder for local AI — from a 0.5B phone model to a 72B coding powerhouse with 262K context.**

## Why Qwen?

Qwen (通义千问) from Alibaba Cloud is the most versatile open-source model family available in 2026. Here's why Western developers should care:

- **Best benchmark-to-cost ratio** in every size class
- **262K context window** (vs GPT-4o's 128K) — process entire codebases, books, and research papers
- **Strong tool calling** — beats Llama 4 and matches GPT-4o on BFCL
- **Open-weight, Apache 2.0 license** — free for commercial use
- **Available in every size** — from a 0.5B phone model to 72B full-density

### Qwen in 2026: Two Generations

| Generation | Ollama Name | Sizes | Best For |
|:----------:|:-----------:|:-----:|:---------|
| **Qwen 3.6** | `qwen3.6` | 27B, 35B | Cutting-edge reasoning, coding | 
| **Qwen 2.5** | `qwen2.5` | 0.5B, 1.5B, 3B, 7B, 14B, 32B, 72B | Maximum compatibility, all hardware |

> **Quick recommendation:** If you have 16GB+ VRAM, go with **Qwen 3.6:27b**. If you have less, **Qwen 2.5:7b** or **Qwen 2.5:14b** are the most battle-tested choices.

---

## Which Model Should You Pull?

### Hardware Decision Table

| Your Setup | Pull Command | VRAM | Speed | Quality |
|:-----------|:-------------|:----:|:-----:|:-------:|
| **High-end** (RTX 4090 / 5090, 24GB) | `ollama pull qwen3.6:27b` | ~15 GB | 25-35 tok/s | 🟢 Excellent |
| **Mid-range** (RTX 4060 / 4070, 12GB) | `ollama pull qwen2.5:14b` | ~9 GB | 30-45 tok/s | 🟢 Excellent |
| **Entry GPU** (RTX 3060 / 4060, 8GB) | `ollama pull qwen2.5:7b` | ~5 GB | 35-55 tok/s | 🟢 Great |
| **Mac M1/M2/3** (16GB unified) | `ollama pull qwen2.5:7b` | ~5 GB shared | 15-25 tok/s | 🟢 Great |
| **Mac M4** (36GB unified) | `ollama pull qwen3.6:27b` | ~15 GB shared | 20-30 tok/s | 🟢 Excellent |
| **CPU only** (32GB RAM) | `ollama pull qwen2.5:7b` | N/A | 1-4 tok/s | 🟢 Good |
| **Laptop / Low RAM** (16GB) | `ollama pull qwen2.5:1.5b` | N/A | 5-10 tok/s | 🟡 Decent |
| **Phone / Edge** (8GB) | `ollama pull qwen2.5:0.5b` | N/A | 10-20 tok/s | 🟡 Basic |

---

## Getting Started (5 Minutes)

```bash
# Install Ollama if you haven't
curl -fsSL https://ollama.com/install.sh | sh

# For most users — the best balance of quality and speed
ollama pull qwen2.5:7b

# Start chatting
ollama run qwen2.5:7b
```

**Try the 262K context:** Qwen is famous for its long context handling.

```
>>> Summarize this 100-page document in 3 bullet points:
[paste your document here — it can be very long!]
```

---

## Qwen 3.6: The Next Generation

Qwen 3.6 is the latest in the Qwen family as of mid-2026. Key improvements:

- **Hybrid MoE architecture** — 27B active parameters from a much larger pool
- **262K native context** — tested successfully at 1M+ tokens
- **Coding-optimized variant** — `qwen3.6:27b-coding` is fine-tuned specifically for code
- **Multilingual excellence** — strong in English, Chinese, Japanese, Korean, Arabic
- **Tool use leadership** — best-in-class BFCL scores among open models

```bash
# Pull the latest Qwen
ollama pull qwen3.6:27b

# Or the coding-optimized version
ollama pull qwen3.6:27b-coding
```

### Qwen 3.6 vs GPT-4o vs DeepSeek-R1

| Capability | Qwen 3.6:27b | DeepSeek-R1:32b | GPT-4o |
|:-----------|:------------:|:---------------:|:------:|
| Coding (HumanEval) | 80.3% | **87.1%** | 84.2% |
| Math (GSM8K) | 90.8% | **94.5%** | 92.0% |
| General Knowledge (MMLU) | 79.5% | **81.3%** | 80.1% |
| **Tool Calling (BFCL)** | **77.3%** | 74.1% | **79.5%** |
| Context Length | **262K** | 128K | 128K |
| VRAM Needed | ~15 GB | ~19 GB | Cloud-only |

> **Bottom line:** If you need **tool use / function calling** or **long context**, Qwen 3.6 is the best local choice. If you need pure **reasoning power**, DeepSeek-R1 wins.

---

## Customizing Qwen with Modelfile

Qwen responds exceptionally well to custom system prompts. Here are production-tested configurations:

### Coding Assistant Config

```dockerfile
FROM qwen2.5:14b

PARAMETER temperature 0.2
PARAMETER top_p 0.9
PARAMETER num_ctx 65536
PARAMETER repeat_penalty 1.1

SYSTEM """You are a senior software engineer with 15 years of experience.
YOU MUST:
- Write clean, production-ready code
- Include type hints and docstrings
- Handle errors gracefully
- Prefer standard library over external dependencies
- Explain your approach briefly before writing code
NEVER apologize. Just write the code."""
```

```bash
ollama create qwen-coder -f Modelfile
ollama run qwen-coder
```

### Creative Writing Config

```dockerfile
FROM qwen2.5:7b

PARAMETER temperature 0.9
PARAMETER top_p 0.95
PARAMETER num_ctx 32768

SYSTEM """You are a creative writing assistant with a gift for vivid description.
Write in the style the user requests.
If asked for a story, provide a complete narrative with character arcs.
For poetry, match the requested form (haiku, sonnet, free verse, etc.)."""
```

---

## Advanced: RAG with Qwen's 262K Context

Qwen's long context makes it excellent for RAG (Retrieval-Augmented Generation) without needing complex chunking strategies.

### Setup with Ollama + AnythingLLM

```bash
# 1. Install AnythingLLM
# Download from https://anythingllm.com

# 2. Configure AnythingLLM:
#    Settings → LLM Provider → Ollama
#    Model: qwen2.5:7b (or qwen3.6:27b)
#    Max Tokens: 8192

# 3. Upload your documents
#    Go to Workspace Settings → Upload Document
#    Click "Save and Embed"

# 4. Ask questions about your documents
#    Qwen's 262K context means it can handle huge documents
#    without losing track of the beginning
```

### Using LangChain

```python
from langchain_ollama import ChatOllama
from langchain_community.document_loaders import TextLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import FAISS
from langchain_ollama import OllamaEmbeddings

# Initialize Qwen
llm = ChatOllama(model="qwen2.5:7b", temperature=0.3)

# Load and chunk documents
loader = TextLoader("your-document.txt")
docs = loader.load()
splitter = RecursiveCharacterTextSplitter(
    chunk_size=8000,
    chunk_overlap=200
)
chunks = splitter.split_documents(docs)

# Create vector store
embeddings = OllamaEmbeddings(model="qwen2.5:7b")
vectorstore = FAISS.from_documents(chunks, embeddings)

# Query
query = "What are the key findings?"
relevant_docs = vectorstore.similarity_search(query, k=3)
context = "\n\n".join([doc.page_content for doc in relevant_docs])

response = llm.invoke(f"Based on these documents:\n{context}\n\nQuestion: {query}")
print(response)
```

---

## API Mode (OpenAI-Compatible)

Like all Ollama models, Qwen exposes an OpenAI-compatible API:

```bash
curl http://localhost:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen2.5:7b",
    "messages": [
      {"role": "system", "content": "You are a Python expert."},
      {"role": "user", "content": "Write a decorator that measures execution time"}
    ],
    "temperature": 0.3
  }'
```

**Use with any OpenAI SDK:**

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:11434/v1",
    api_key="ollama"  # required by client, but Ollama ignores it
)

response = client.chat.completions.create(
    model="qwen2.5:7b",
    messages=[{"role": "user", "content": "Hello!"}]
)
print(response.choices[0].message.content)
```

---

## Common Pitfalls

| Problem | Cause | Fix |
|---------|-------|-----|
| Model responds in Chinese | Qwen's default template includes Chinese | Add `SYSTEM "Always respond in English."` to Modelfile |
| Slow on high-end GPU | Only using CPU layers | Set `OLLAMA_GPU_LAYERS=999` environment variable |
| Wrong model pulled | `qwen3.6` vs `qwen2.5` confusion | `ollama pull qwen3.6:27b` for latest, `qwen2.5:7b` for stability |
| "Ollama not found" after install | PATH not updated | Restart terminal or run `export PATH=$PATH:/usr/local/bin` |
| Context overload | Prompt exceeds model's limit | Keep within 262K tokens (≈200,000 words) for qwen3.6 |
| Poor code output | Temperature too high | Set `temperature 0.2` in Modelfile for coding tasks |

---

## Why Western Developers Should Switch to Qwen

1. **Apache 2.0 license** — no restrictions, no usage caps, no "you can't compete with us" clauses
2. **Tool calling that works** — Qwen 3.6 leads the open-source pack on BFCL benchmarks
3. **262K context** — 2x GPT-4o's context, for free, on your machine
4. **Runs on anything** — from a Raspberry Pi (0.5B) to a multi-GPU server (72B)
5. **Weirdly good at English** — despite being from Alibaba, Qwen's English output rivals Western models
6. **Active ecosystem** — Hugging Face has 1000+ Qwen fine-tunes, GGUF quants, and LoRAs

The message global developers need to hear: **You don't need OpenAI or Google for state-of-the-art AI. The best all-rounder is from Alibaba, and it's free.**

---

## Next Steps

- **Pull the model now:** `ollama pull qwen2.5:7b` (get started) or `ollama pull qwen3.6:27b` (cutting-edge)
- **Build a RAG system:** See the [RAG guide](../04-advanced-usage/rag.md)
- **Try function calling:** Qwen excels at tool use — see [Chapter 06](../06-function-calling/)
- **Set up Open WebUI:** A ChatGPT-like interface for Qwen — see [Chapter 04](../04-advanced-usage/open-webui.md)

---

*Part of the [Local LLM Guide](https://github.com/Lingdas1/local-llm-guide) — the definitive resource for running AI on your own hardware.*
