#!/usr/bin/env bash
# hardware-check.sh — Detect GPU, VRAM, RAM, and recommend models
set -e

echo "=== Hardware Detection ==="

# OS
OS="$(uname -s)"
echo "OS: $OS"

# RAM
if [[ "$OS" == "Linux" ]]; then
  TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
  echo "RAM: ${TOTAL_RAM}GB"
elif [[ "$OS" == "Darwin" ]]; then
  TOTAL_RAM=$(($(sysctl -n hw.memsize) / 1024 / 1024 / 1024))
  echo "RAM: ${TOTAL_RAM}GB"
fi

# GPU
if command -v nvidia-smi &> /dev/null; then
  GPU_NAME=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1)
  VRAM_GB=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null | head -1)
  VRAM_GB=$((VRAM_GB / 1024))
  echo "GPU: $GPU_NAME"
  echo "VRAM: ${VRAM_GB}GB"
  
  # Recommend model
  if [ "$VRAM_GB" -ge 24 ]; then
    echo "💡 Recommended: DeepSeek V4 (Q3) or Qwen 3.5:35B-A3B"
  elif [ "$VRAM_GB" -ge 12 ]; then
    echo "💡 Recommended: Qwen 3.5:9B or DeepSeek V4 Lite"
  elif [ "$VRAM_GB" -ge 8 ]; then
    echo "💡 Recommended: Qwen 3.5:7B or Gemma 4:9B (Q4)"
  else
    echo "💡 Recommended: Qwen 3.5:1.7B or Phi-4 Mini"
  fi
elif command -v rocminfo &> /dev/null; then
  echo "GPU: AMD (ROCm detected)"
  echo "💡 Recommended: Qwen 3.5:9B or DeepSeek V4 Lite (see AMD guide)"
elif [[ "$OS" == "Darwin" ]]; then
  echo "GPU: Apple Silicon (Metal)"
  if [ "$TOTAL_RAM" -ge 32 ]; then
    echo "💡 Recommended: DeepSeek V4 Lite or Qwen 3.5:14B"
  elif [ "$TOTAL_RAM" -ge 16 ]; then
    echo "💡 Recommended: Qwen 3.5:9B or Gemma 4:9B"
  else
    echo "💡 Recommended: Qwen 3.5:1.7B"
  fi
else
  echo "GPU: None detected (CPU-only mode)"
  if [ "$TOTAL_RAM" -ge 32 ]; then
    echo "💡 Recommended: Qwen 3.5:9B (Q4, expect 2-6 tok/s)"
  elif [ "$TOTAL_RAM" -ge 16 ]; then
    echo "💡 Recommended: Qwen 3.5:1.7B (CPU)"
  else
    echo "💡 Recommended: Qwen 3.5:0.8B or Phi-4 Mini"
  fi
fi
