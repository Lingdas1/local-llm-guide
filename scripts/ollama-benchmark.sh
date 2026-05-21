#!/usr/bin/env bash
# ollama-benchmark.sh — Run standardized benchmarks on installed models
set -e

echo "=== Ollama Benchmark ==="
echo ""

# Check if models are provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <model1> [model2] [model3] ..."
  echo "Example: $0 qwen3.5:9b deepseek-v4:lite"
  echo ""
  echo "Available models:"
  ollama list 2>/dev/null || echo "(run 'ollama list' after pulling models)"
  exit 1
fi

PROMPT="Write a Python function to compute fibonacci numbers recursively. Include comments."

for MODEL in "$@"; do
  echo "--- Benchmarking: $MODEL ---"
  
  # Cold start (first run after loading)
  echo "Cold start..."
  START_TIME=$(date +%s%N)
  RESPONSE=$(ollama run "$MODEL" "$PROMPT" 2>/dev/null)
  END_TIME=$(date +%s%N)
  COLD_MS=$(( (END_TIME - START_TIME) / 1000000 ))
  
  # Count tokens (rough estimate)
  TOKENS=$(echo "$RESPONSE" | wc -w)
  TOKENS=$((TOKENS * 2))  # rough word→token ratio for English
  
  echo "Cold start time: ${COLD_MS}ms"
  echo "Response length: ~${TOKENS}tokens"
  
  # Warm run
  echo "Warm run..."
  START_TIME=$(date +%s%N)
  RESPONSE2=$(ollama run "$MODEL" "$PROMPT" 2>/dev/null)
  END_TIME=$(date +%s%N)
  WARM_MS=$(( (END_TIME - START_TIME) / 1000000 ))
  
  echo "Warm run time: ${WARM_MS}ms"
  if [ $WARM_MS -gt 0 ]; then
    TOKENS_PER_SEC=$(( TOKENS * 1000 / WARM_MS ))
    echo "Speed: ~${TOKENS_PER_SEC} tok/s"
  fi
  echo ""
done
