#!/usr/bin/env bash
# modelfile-generator.sh — Interactive Modelfile creator
set -e

echo "=== Modelfile Generator ==="
echo ""

# Get GGUF path
read -p "Path to GGUF file: " GGUF_PATH
if [ ! -f "$GGUF_PATH" ]; then
  echo "❌ File not found: $GGUF_PATH"
  exit 1
fi

# Get model name
read -p "Model name (e.g., my-custom-model): " MODEL_NAME

# Parameters
read -p "Temperature [0.7]: " TEMP
TEMP=${TEMP:-0.7}

read -p "Context length [8192]: " CTX
CTX=${CTX:-8192}

read -p "System prompt (optional): " SYS_PROMPT

# Generate Modelfile
OUTPUT="Modelfile"
cat > "$OUTPUT" << EOF
FROM $(basename "$GGUF_PATH")

PARAMETER temperature $TEMP
PARAMETER num_ctx $CTX
EOF

if [ -n "$SYS_PROMPT" ]; then
  echo "SYSTEM \"\"\"$SYS_PROMPT\"\"\"" >> "$OUTPUT"
fi

echo ""
echo "✅ Modelfile created!"
echo "---"
cat "$OUTPUT"
echo "---"
echo ""
echo "Run: ollama create $MODEL_NAME -f $OUTPUT"
echo "Then: ollama run $MODEL_NAME"
