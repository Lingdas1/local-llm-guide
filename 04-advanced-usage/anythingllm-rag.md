# Local RAG: Chat With Your Documents

> **Upload PDFs, code, research papers, or entire books — then ask your local LLM questions about them. No data ever leaves your machine.**

## What Is RAG? (Plain English)

**RAG** (Retrieval-Augmented Generation) means your LLM can look up information from your own documents before answering.

Think of it like this:
- **Normal LLM:** Has a great memory, but only knows what it learned during training
- **RAG:** The LLM gets a "cheat sheet" — your documents — that it can read before answering

> 💡 **Analogy:** Without RAG, the LLM is like a student taking a closed-book exam. With RAG, they get an open-book exam — and you get to write the book.

### Real-World Uses

| Use Case | What You Upload | What You Can Ask |
|:---------|:---------------|:-----------------|
| Research | PDF papers, articles | "What were the key findings in this study?" |
| Studying | Textbooks, lecture notes | "Explain chapter 7 in simpler terms" |
| Work | Company docs, reports | "What's our Q3 strategy?" |
| Legal | Contracts, agreements | "What are the termination clauses?" |
| Coding | Codebase, documentation | "How does the auth module work?" |
| Personal | Journals, notes, books | "What did I write about in March?" |

---

## Option A: Built-in RAG in Open WebUI (Simplest)

If you already have [Open WebUI installed](./open-webui-setup.md), RAG is built-in.

### How to Use It

1. Open **http://localhost:3000** in your browser
2. Click the **paperclip icon** next to the chat input
3. Upload a PDF, .txt, .docx, or .md file
4. Wait for the "embedding" process to finish (usually 10-30 seconds)
5. Ask questions about the document

**That's it.** No configuration needed.

### Pro Tips

- **Multiple documents:** You can upload several files at once. Open WebUI indexes them all.
- **Model choice:** Use `qwen3.6:27b` or `deepseek-r1:14b` for best RAG quality — they have larger context windows.
- **Document size:** Open WebUI handles documents up to hundreds of pages. For very large documents, consider chunking them.

---

## Option B: AnythingLLM (More Powerful)

[AnythingLLM](https://anythingllm.com) is a dedicated RAG application with more features than Open WebUI's built-in system.

### Installation

**With Docker (Recommended):**

```bash
docker run -d \
  -p 3001:3001 \
  -v anythingllm:/app/server/storage \
  -e STORAGE_DIR=/app/server/storage \
  --name anythingllm \
  --restart always \
  ghcr.io/anythingllm/anything-llm:latest
```

Then open **http://localhost:3001**.

**Without Docker:**

Download from [anythingllm.com](https://anythingllm.com) and run the installer for your OS.

### Configuration

1. **Open AnythingLLM** at `http://localhost:3001`
2. **Create an admin account** (local only — no data leaves your machine)
3. **Go to Settings → LLM Provider**
4. **Select Ollama** from the dropdown
5. **Choose your model** (e.g., `qwen2.5:7b` or `deepseek-r1:14b`)
6. **Click Save**

Now set up embeddings:

7. **Go to Settings → Embedding Provider**
8. **Select Ollama**
9. **Choose an embedding model** (AnythingLLM will download a small embedding model — about 500 MB)
10. **Click Save**

### Uploading Documents

1. Click **"New Workspace"** and give it a name (e.g., "Research Papers")
2. Click the **upload icon** (or drag and drop files)
3. Supported formats: PDF, DOCX, TXT, MD, CSV, JSON, code files
4. Click **"Save and Embed"**
5. Wait for indexing (progress shows in the UI)

### Chatting With Your Documents

Once embedded, just type your question:

```
"What are the three main conclusions from these papers?"
```

AnythingLLM searches your documents for relevant passages and feeds them to the LLM along with your question. The result is **accurate, sourced answers** — not guesses.

> 🔥 **Pro tip:** AnythingLLM shows you which document each answer came from. Hover over the citation to see the exact source passage.

---

## Option C: Manual RAG with LangChain (For Developers)

For maximum control, build RAG with Python and LangChain. This is particularly useful if you want to automate document processing.

### Setup

```bash
pip install langchain langchain-ollama chromadb
```

### Basic RAG Script

```python
from langchain_ollama import ChatOllama, OllamaEmbeddings
from langchain_community.document_loaders import DirectoryLoader, TextLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import Chroma
from langchain.chains import RetrievalQA

# 1. Load your documents
loader = DirectoryLoader("./my-docs/", glob="**/*.txt", loader_cls=TextLoader)
documents = loader.load()
print(f"Loaded {len(documents)} documents")

# 2. Split into chunks
splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200
)
chunks = splitter.split_documents(documents)
print(f"Split into {len(chunks)} chunks")

# 3. Create embeddings and vector store
embeddings = OllamaEmbeddings(model="qwen2.5:7b")
vectorstore = Chroma.from_documents(
    documents=chunks,
    embedding=embeddings,
    persist_directory="./chroma_db"
)

# 4. Create RAG chain
llm = ChatOllama(model="qwen2.5:7b", temperature=0.3)
qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    chain_type="stuff",
    retriever=vectorstore.as_retriever(search_kwargs={"k": 3})
)

# 5. Ask questions
while True:
    question = input("\nAsk a question (or 'quit'): ")
    if question.lower() == 'quit':
        break
    answer = qa_chain.invoke(question)
    print(f"\nAnswer: {answer['result']}")
```

### Run It

```bash
# Put your documents in a folder called "my-docs/"
mkdir -p my-docs
# Copy your PDFs/txts there

# Run the script
python rag.py
```

---

## Choosing the Right RAG Setup

| Factor | Open WebUI RAG | AnythingLLM | LangChain |
|:-------|:--------------:|:-----------:|:---------:|
| **Setup time** | 1 click | 5 minutes | 30 minutes |
| **Features** | Basic | Advanced | Full control |
| **Document types** | PDF, TXT, MD | PDF, DOCX, TXT, MD, CSV, code | Anything with a loader |
| **Multi-document** | ✅ | ✅ | ✅ |
| **Citations** | ❌ | ✅ | ✅ (manual) |
| **Customization** | Low | Medium | High |
| **Best for** | Quick personal use | Serious knowledge work | Automation & production |

**My recommendation:**
- **Start** with Open WebUI's built-in RAG (fastest)
- **Move to** AnythingLLM when you need citations and multiple workspaces
- **Use** LangChain when you need to automate document processing

---

## Best Practices for Better RAG Results

### 1. Use the Right Model

RAG works best with models that have **large context windows**:

| Model | Context | Why It's Good for RAG |
|:------|:-------:|:---------------------|
| Qwen 3.6:27B | 262K | Can process entire chapters at once |
| Qwen 2.5:14B | 128K | Excellent balance of quality and speed |
| DeepSeek-R1:14B | 128K | Best for reasoning about documents |
| DeepSeek-R1:32B | 128K | Best overall RAG quality |

### 2. Write Good Questions

| ❌ Bad Question | ✅ Good Question |
|:---------------|:----------------|
| "Tell me about it" | "Summarize the methodology used in section 3" |
| "What's in this?" | "What are the three main arguments presented in chapter 2?" |
| "Is this useful?" | "What evidence does the author provide for their claim on page 15?" |

### 3. Optimize Chunk Size

The chunk size determines how much text the LLM sees at once:

| Chunk Size | Best For |
|:----------:|:---------|
| 500 chars | Short lookup questions ("What is X?") |
| 1000 chars | General Q&A 🟢 Default |
| 2000 chars | Summarization tasks |
| 4000+ chars | Long-context analysis (Qwen 3.6 recommended) |

---

## Common Pitfalls

| Problem | Cause | Fix |
|:--------|:------|:-----|
| "I don't know" to document questions | Embedding not matching | Re-save documents in workspace |
| Wrong answers despite having docs | Chunk size too small | Increase chunk_size to 2000+ |
| Very slow document processing | Large files on CPU | Be patient — first embed takes longest |
| "Model not responding" | Context overflow | Use a model with larger context (Qwen 3.6) |
| Can't upload PDFs | PDF is scanned/image-based | Use OCR first (tools like marker-pdf) |

---

## Next Steps

- **Set up Open WebUI first** (it includes RAG out of the box) → [Open WebUI Guide](./open-webui-setup.md)
- **Try it with Chinese models** → Qwen 3.6 is excellent for RAG due to its 262K context
- **Combine RAG with Function Calling** → [Chapter 06: Function Calling](../06-function-calling/)
- **Deploy in production** → [Chapter 05: Production](../05-production/)

---

> *Part of the [Local LLM Guide](https://github.com/Lingdas1/local-llm-guide) — the definitive resource for running AI on your own hardware.*
