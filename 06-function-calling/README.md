# 06 — Function Calling & Tool Use

> 🔴 **Advanced** — Give your local LLM superpowers: let it call APIs, run code, search the web, and interact with other software — all autonomously.

---

## What Is Function Calling? (Plain English First)

Imagine you ask an assistant: *"What's the weather in Tokyo right now?"*

A normal LLM can only guess — it doesn't know today's weather. But with **function calling**, the LLM can say:

> "I don't know the weather, but I know someone who does. Let me call the weather API."

The pattern is simple:

```
User: "What's the weather in Tokyo?"
  ↓
LLM: "I should call get_weather(city='Tokyo')"
  ↓
Your code: calls the actual weather API → gets result
  ↓
LLM: "The weather in Tokyo is 22°C and sunny."
```

**Function calling = the LLM decides when to use a tool, and your code executes it.**

> 💡 **Why this matters without the cloud:** On a cloud API (GPT-4, Claude), function calling is a checkbox feature. **On local LLMs, it's not automatic** — you need to know which models support it, how to format the tool definitions, and how to handle the response correctly. That's what this chapter covers.

---

## How Function Calling Works (The Technical Pattern)

Every function calling flow follows the same 5-step cycle:

```
Step 1: Define your tools (as JSON schema)
Step 2: Send user message + tool definitions to the LLM
Step 3: LLM responds with either:
         - A normal text reply (no tool needed)
         - A "tool call" request (which tool + what arguments)
Step 4: Your code executes the requested tool
Step 5: Send the tool result back to the LLM
         → LLM produces the final response
```

Here's what a tool definition looks like in JSON:

```json
{
  "type": "function",
  "function": {
    "name": "get_weather",
    "description": "Get current weather for a city",
    "parameters": {
      "type": "object",
      "properties": {
        "city": {
          "type": "string",
          "description": "City name, e.g., 'Tokyo'"
        }
      },
      "required": ["city"]
    }
  }
}
```

---

## 1. DeepSeek-R1: Function Calling

DeepSeek-R1 is **excellent** at function calling — it's one of its standout features. It uses the **OpenAI-compatible format**, which means you can use the same code you'd use with GPT-4.

### Basic Setup

First, make sure DeepSeek-R1 is running locally:

```bash
ollama pull deepseek-r1:14b

# Or for smaller setups:
ollama pull deepseek-r1:7b
```

### Single Tool Call Example (Python)

```python
import json
import requests

# Step 1: Define the tools available to the LLM
tools = [
    {
        "type": "function",
        "function": {
            "name": "get_weather",
            "description": "Get the current weather for a city",
            "parameters": {
                "type": "object",
                "properties": {
                    "city": {"type": "string", "description": "City name"},
                    "unit": {"type": "string", "enum": ["celsius", "fahrenheit"]}
                },
                "required": ["city"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "calculator",
            "description": "Perform a mathematical calculation",
            "parameters": {
                "type": "object",
                "properties": {
                    "expression": {
                        "type": "string",
                        "description": "Math expression, e.g., '2 + 2' or 'sqrt(144)'"
                    }
                },
                "required": ["expression"]
            }
        }
    }
]

# Step 2: Send message + tools to the model
def chat_with_tools(messages, tools):
    response = requests.post(
        "http://localhost:11434/v1/chat/completions",
        json={
            "model": "deepseek-r1:14b",
            "messages": messages,
            "tools": tools,
            "stream": False
        }
    )
    return response.json()

# Step 3: Execute tool calls and return results
def execute_tool(tool_call):
    """Execute the tool the LLM requested and return the result."""
    name = tool_call["function"]["name"]
    args = json.loads(tool_call["function"]["arguments"])
    
    if name == "get_weather":
        # In real code, you'd call a real weather API here
        city = args["city"]
        unit = args.get("unit", "celsius")
        return json.dumps({
            "city": city,
            "temperature": 22 if unit == "celsius" else 72,
            "condition": "Sunny",
            "humidity": "65%"
        })
    
    elif name == "calculator":
        try:
            result = eval(args["expression"], {"__builtins__": {}}, {
                "sqrt": __import__("math").sqrt,
                "sin": __import__("math").sin,
                "cos": __import__("math").cos,
                "pi": __import__("math").pi
            })
            return json.dumps({"result": result})
        except Exception as e:
            return json.dumps({"error": str(e)})
    
    return json.dumps({"error": f"Unknown tool: {name}"})

# Step 4: Run the full interaction
def run_with_tools(user_message):
    messages = [
        {"role": "system", "content": "You are a helpful assistant with access to tools."},
        {"role": "user", "content": user_message}
    ]
    
    # First LLM call
    response = chat_with_tools(messages, tools)
    response_message = response["choices"][0]["message"]
    messages.append(response_message)
    
    # Check if the LLM wants to call tools
    if response_message.get("tool_calls"):
        for tool_call in response_message["tool_calls"]:
            result = execute_tool(tool_call)
            messages.append({
                "role": "tool",
                "tool_call_id": tool_call["id"],
                "content": result
            })
        
        # Second LLM call — now it has the tool results
        final_response = chat_with_tools(messages, tools)
        return final_response["choices"][0]["message"]["content"]
    
    return response_message["content"]

# Test it
print(run_with_tools("What's the weather in Tokyo in celsius?"))
# → "The weather in Tokyo is 22°C and sunny."

print(run_with_tools("Calculate 2^10 + 5*3"))
# → "The result is 1024 + 15 = 1039."
```

### Key Differences from Cloud APIs

| Aspect | GPT-4 (Cloud) | DeepSeek-R1 (Local) |
|--------|--------------|---------------------|
| `tool_choice` | Supports `"auto"`, `"required"`, `"none"` | Supports `"auto"` and `"none"` |
| Parallel tool calls | ✅ Yes | ✅ Yes (multiple tools in one response) |
| Streaming with tools | ✅ Yes | ⚠️ Partially (use `stream: false` for reliability) |
| Response format | OpenAI format | OpenAI-compatible ✅ |

> **Tip:** If DeepSeek-R1 doesn't call tools when you expect it to, try adding explicit instructions in the system prompt like: *"You have access to tools. Use them when the user asks for information you don't know."*

---

## 2. Qwen 3.6 / 2.5: Function Calling

Qwen models have **native function calling support** and are particularly good at following complex tool schemas.

### Setup

```bash
# Qwen 3.6 (newer, better function calling)
ollama pull qwen3.6:8b

# Or Qwen 2.5 (more widely tested)
ollama pull qwen2.5:7b
```

### Example: Multi-Tool Chatbot

```python
import json
import requests

def qwen_chat_with_tools(messages, tools):
    """Qwen uses the same OpenAI-compatible format."""
    response = requests.post(
        "http://localhost:11434/v1/chat/completions",
        json={
            "model": "qwen3.6:8b",  # or "qwen2.5:7b"
            "messages": messages,
            "tools": tools,
            "tool_choice": "auto",
            "temperature": 0.3,  # Lower = more deterministic tool selection
            "stream": False
        }
    )
    return response.json()

# Define a web search tool (mock)
tools = [
    {
        "type": "function",
        "function": {
            "name": "search_web",
            "description": "Search the internet for current information",
            "parameters": {
                "type": "object",
                "properties": {
                    "query": {"type": "string", "description": "Search query"}
                },
                "required": ["query"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "read_file",
            "description": "Read contents of a file on the local system",
            "parameters": {
                "type": "object",
                "properties": {
                    "path": {"type": "string", "description": "Absolute file path"}
                },
                "required": ["path"]
            }
        }
    }
]

def execute_qwen_tool(tool_call):
    name = tool_call["function"]["name"]
    args = json.loads(tool_call["function"]["arguments"])
    
    if name == "search_web":
        # In production, use a real search API
        return json.dumps({
            "query": args["query"],
            "results": [
                {"title": f"Result about {args['query']}", "url": "https://example.com"}
            ]
        })
    elif name == "read_file":
        try:
            with open(args["path"], "r") as f:
                content = f.read()[:2000]  # Limit to 2000 chars
            return json.dumps({"path": args["path"], "content": content})
        except Exception as e:
            return json.dumps({"error": str(e)})
    
    return json.dumps({"error": "Unknown tool"})

# Full interaction loop
messages = [
    {"role": "system", "content": "You are an AI assistant with access to search and file tools. Use them when needed."}
]

user_input = "Can you read my config file and tell me what model I'm using?"
messages.append({"role": "user", "content": user_input})

# First response
response = qwen_chat_with_tools(messages, tools)
msg = response["choices"][0]["message"]
messages.append(msg)

# Handle tool calls
if msg.get("tool_calls"):
    for tc in msg["tool_calls"]:
        result = execute_qwen_tool(tc)
        messages.append({
            "role": "tool",
            "tool_call_id": tc["id"],
            "content": result
        })
    
    # Get final response
    final = qwen_chat_with_tools(messages, tools)
    print(final["choices"][0]["message"]["content"])
```

### Qwen-Specific Tips

| Tip | Why |
|-----|-----|
| **Use `temperature: 0.3`** | Qwen is more creative by default; lower temp = more reliable tool selection |
| **Describe tools in Chinese + English** | Qwen was trained bilingually; descriptions in English work fine, but Chinese descriptions can improve accuracy |
| **Max 5 parallel tools** | Qwen 3.6 supports parallel tool calls but performs best with ≤5 at once |
| **Use `tool_choice: "auto"`** | Explicitly setting this prevents the model from ignoring tools |

---

## 3. GLM-4.7: Tool Use & Agents

**GLM-4** (from Zhipu AI / z.ai) is specifically designed for **agentic workflows**. It has the strongest tool-use capabilities among Chinese local models — it was trained with tool use as a first-class feature, not an afterthought.

### Setup

```bash
ollama pull glm4:9b
```

### GLM's Unique Tool Format

GLM uses a slightly different tool definition format. Note the **`required_parameters`** field instead of `required`:

```python
import json
import requests

# GLM tool definition format
glm_tools = [
    {
        "type": "function",
        "function": {
            "name": "send_email",
            "description": "Send an email to a recipient",
            "parameters": {
                "type": "object",
                "properties": {
                    "to": {"type": "string", "description": "Recipient email address"},
                    "subject": {"type": "string", "description": "Email subject"},
                    "body": {"type": "string", "description": "Email body content"}
                },
                "required_parameters": ["to", "subject", "body"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "list_directory",
            "description": "List files in a directory",
            "parameters": {
                "type": "object",
                "properties": {
                    "path": {"type": "string", "description": "Directory path"}
                },
                "required_parameters": ["path"]
            }
        }
    }
]

def glm_chat(messages, tools):
    response = requests.post(
        "http://localhost:11434/v1/chat/completions",
        json={
            "model": "glm4:9b",
            "messages": messages,
            "tools": tools,
            "stream": False
        }
    )
    return response.json()
```

### Multi-Step Agent Example

GLM-4 excels at **multi-step reasoning** — deciding to call tools in sequence:

```python
messages = [
    {"role": "system", "content": "You are an AI assistant that can use tools. Use them when helpful."},
    {"role": "user", "content": "List the files in /home/user/projects, then tell me which ones are Python files."}
]

# GLM will:
# 1. Call list_directory("/home/user/projects")
# 2. Receive the file list
# 3. Analyze and respond with which are Python files

response = glm_chat(messages, glm_tools)
msg = response["choices"][0]["message"]

if msg.get("tool_calls"):
    for tc in msg["tool_calls"]:
        result = execute_glm_tool(tc)  # Your tool execution function
        messages.append({
            "role": "tool",
            "tool_call_id": tc["id"],
            "content": result
        })
    
    # GLM will now synthesize the results
    final = glm_chat(messages, glm_tools)
    print(final["choices"][0]["message"]["content"])
```

### GLM vs Others: When to Use Each

| Task | Best Model | Why |
|------|-----------|-----|
| Simple tool call (1-2 tools) | DeepSeek-R1:7b | Fastest inference, reliable |
| Complex multi-step (3+ tools) | **GLM-4:9b** | Best agentic reasoning |
| Following exact tool schema | **Qwen 3.6:8b** | Most accurate parameter extraction |
| Cost-sensitive (low VRAM) | Qwen 2.5:7b | 4.5GB at Q4, works on most GPUs |

---

## 4. LangChain Integration

LangChain is the most popular framework for building LLM-powered applications. Here's how to use your local models with function calling in LangChain.

### Installation

```bash
pip install langchain langchain-community
```

### Basic LangChain + Ollama Tools

```python
from langchain_community.chat_models import ChatOllama
from langchain.agents import AgentExecutor, create_tool_calling_agent
from langchain.tools import tool
from langchain_core.prompts import ChatPromptTemplate

# Step 1: Define tools using the @tool decorator
@tool
def get_weather(city: str) -> str:
    """Get current weather for a city. Input: city name."""
    # Replace with real API call
    return f"The weather in {city} is 22°C and sunny."

@tool
def calculate(expression: str) -> str:
    """Perform a mathematical calculation. Input: math expression string."""
    import math
    safe_dict = {
        "sqrt": math.sqrt, "sin": math.sin, "cos": math.cos,
        "pi": math.pi, "e": math.e, "abs": abs
    }
    try:
        result = eval(expression, {"__builtins__": {}}, safe_dict)
        return f"Result: {result}"
    except Exception as e:
        return f"Error: {e}"

@tool
def search_web(query: str) -> str:
    """Search the web for current information. Input: search query."""
    # In production, use DuckDuckGo or similar
    return f"Top result for '{query}': [Example result]"

# Step 2: Create the LLM
llm = ChatOllama(
    model="qwen2.5:7b",  # or "deepseek-r1:7b", "glm4:9b"
    temperature=0.3,
)

# Step 3: Create the agent
tools = [get_weather, calculate, search_web]
prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful AI assistant with access to tools."),
    ("human", "{input}"),
    ("placeholder", "{agent_scratchpad}"),
])

agent = create_tool_calling_agent(llm, tools, prompt)
agent_executor = AgentExecutor(
    agent=agent,
    tools=tools,
    verbose=True,  # Shows you what tools are being called
    max_iterations=5,  # Safety limit
)

# Step 4: Run it
result = agent_executor.invoke({
    "input": "What's the weather in London and calculate 15% of 200?"
})
print(result["output"])
# → "The weather in London is 22°C and sunny. 15% of 200 is 30."
```

### Running the LangChain Example

```bash
# Save the code above as langchain-agent.py
python langchain-agent.py

# You should see:
# > Entering new AgentExecutor chain...
# > Invoking: get_weather with {'city': 'London'}
# > Invoking: calculate with {'expression': '0.15 * 200'}
# > The weather in London is 22°C and sunny. 15% of 200 is 30.
```

### Model-Specific LangChain Tips

| Model | LangChain Model Class | Notes |
|-------|----------------------|-------|
| DeepSeek-R1 | `ChatOllama(model="deepseek-r1:14b")` | Best for reasoning-heavy agents |
| Qwen 3.6/2.5 | `ChatOllama(model="qwen3.6:8b")` | Most reliable with LangChain's tool format |
| GLM-4 | `ChatOllama(model="glm4:9b")` | May need `stop: ["<|im_end|>"]` for proper termination |

---

## 5. Practical: Build a Code Assistant Bot

Let's put it all together — a real tool-using assistant that can:

- Read and write files
- Run shell commands
- Search for packages
- Answer questions about your codebase

```python
import json
import requests
import subprocess
import os

# === Tool Definitions ===

TOOLS = [
    {
        "type": "function",
        "function": {
            "name": "read_file",
            "description": "Read the contents of a file",
            "parameters": {
                "type": "object",
                "properties": {
                    "path": {"type": "string", "description": "Absolute path to file"}
                },
                "required": ["path"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "write_file",
            "description": "Write content to a file (overwrites existing)",
            "parameters": {
                "type": "object",
                "properties": {
                    "path": {"type": "string"},
                    "content": {"type": "string", "description": "File content"}
                },
                "required": ["path", "content"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "run_command",
            "description": "Run a shell command (read-only, safe commands only)",
            "parameters": {
                "type": "object",
                "properties": {
                    "command": {"type": "string", "description": "Shell command to run"}
                },
                "required": ["command"]
            }
        }
    }
]

def execute(name, args):
    if name == "read_file":
        try:
            with open(args["path"], "r") as f:
                return f.read()[:3000]
        except Exception as e:
            return f"Error: {e}"
    
    elif name == "write_file":
        try:
            with open(args["path"], "w") as f:
                f.write(args["content"])
            return f"Written {len(args['content'])} bytes to {args['path']}"
        except Exception as e:
            return f"Error: {e}"
    
    elif name == "run_command":
        # Safety: only allow read-only commands
        safe_prefixes = ["ls", "cat", "grep", "find", "pwd", "echo", "which", "head", "tail"]
        cmd = args["command"].split()[0]
        if cmd not in safe_prefixes:
            return f"Blocked: '{cmd}' is not in the allowed command list."
        try:
            result = subprocess.run(
                args["command"], shell=True, capture_output=True,
                text=True, timeout=10
            )
            output = (result.stdout + result.stderr)[:3000]
            return output if output else "(no output)"
        except subprocess.TimeoutExpired:
            return "Command timed out after 10 seconds"
        except Exception as e:
            return f"Error: {e}"

# === Main Loop ===

def chat_tool(ollama_host="http://localhost:11434", model="qwen2.5:7b"):
    messages = [{
        "role": "system",
        "content": "You are a coding assistant. Use your tools to read files, write code, and run commands."
    }]
    
    print(f"🤖 Code Assistant ({model}) — type 'quit' to exit\n")
    
    while True:
        user = input("You: ")
        if user.lower() in ("quit", "exit", "q"):
            break
        
        messages.append({"role": "user", "content": user})
        
        # Tool-call loop (max 5 iterations to prevent infinite loops)
        for i in range(5):
            resp = requests.post(
                f"{ollama_host}/v1/chat/completions",
                json={
                    "model": model,
                    "messages": messages,
                    "tools": TOOLS,
                    "stream": False
                }
            ).json()
            
            msg = resp["choices"][0]["message"]
            messages.append(msg)
            
            if not msg.get("tool_calls"):
                break  # No more tools needed
            
            # Execute each tool
            for tc in msg["tool_calls"]:
                fn_name = tc["function"]["name"]
                fn_args = json.loads(tc["function"]["arguments"])
                print(f"  🔧 Calling: {fn_name}({json.dumps(fn_args)})")
                result = execute(fn_name, fn_args)
                messages.append({
                    "role": "tool",
                    "tool_call_id": tc["id"],
                    "content": str(result)
                })
        
        # Print final response
        print(f"🤖 {msg['content']}\n")

if __name__ == "__main__":
    chat_tool()
```

**Save and run:**
```bash
python3 code-assistant.py
```

**Example interaction:**
```
You: Read my main.py and tell me if there are any bugs
  🔧 Calling: read_file({"path": "./main.py"})
🤖 I can see your main.py. It looks mostly fine, but I notice
   line 42 has a typo: "retrun" should be "return".

You: Fix it
  🔧 Calling: read_file({"path": "./main.py"})
  🔧 Calling: write_file({"path": "./main.py", "content": "..."})
🤖 Fixed! Changed "retrun" to "return" on line 42.
```

---

## Quick Reference: Model Function Calling Support

| Feature | DeepSeek-R1 | Qwen 3.6 / 2.5 | GLM-4 | Notes |
|---------|------------|-----------------|-------|-------|
| OpenAI format | ✅ | ✅ | ✅ | Same `tools` parameter |
| Parallel calls | ✅ | ✅ | ✅ | Multiple tools at once |
| `tool_choice: "auto"` | ✅ | ✅ | ✅ | LLM decides when to use tools |
| `tool_choice: "required"` | ❌ | ⚠️ Partial | ❌ | Not widely supported locally |
| Streaming + tools | ⚠️ Partial | ✅ | ⚠️ Partial | Use `stream: false` to be safe |
| Multi-step reasoning | Good | Very Good | **Excellent** | GLM-4 leads on agentic workflows |
| Min VRAM (Q4) | ~4.5 GB (7b) | ~5 GB (8b) | ~5.5 GB (9b) | All fit on 8GB GPUs |

---

## Common Mistakes & Solutions

| Mistake | Symptom | Fix |
|---------|---------|-----|
| **Wrong model name** | "does not support tools" error | Verify: `curl -s http://localhost:11434/api/tags` |
| **Missing system prompt** | Model never calls tools | Add: "You have access to tools. Use them when helpful." |
| **Too many tools** | Model calls wrong tool | Limit to ≤5 tool definitions per call |
| **No `tool_choice: "auto"`** | Model ignores tools | Explicitly set `tool_choice: "auto"` |
| **Infinite tool loop** | Model keeps calling tools | Add `max_iterations` guard (e.g., 5) |
| **Temperature too high** | Tool calls are random/lazy | Set `temperature: 0.3` or lower |
| **Wrong Ollama port** | Connection refused | Check: `ollama serve` is running on 11434 |

---

## What's Next

You now have a local LLM that can **see files, run commands, search the web, and execute code**. This is the foundation for building:

- **AI coding assistants** that read and modify your codebase
- **Personal research agents** that search the web and summarize
- **Automation bots** that interact with APIs and databases
- **Your own AutoGPT** — a multi-step reasoning agent

The [GitHub repo](https://github.com/Lingdas1/local-llm-guide) has ready-to-run scripts for all the examples above. Star it to get notified when new chapters drop! ⭐

---

*Found this useful? ⭐ [Star the repo](https://github.com/Lingdas1/local-llm-guide) — it helps others find it and you'll get notified when new chapters drop.*
