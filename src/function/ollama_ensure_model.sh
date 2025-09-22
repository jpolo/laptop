#!/usr/bin/env bash

# Ensure the specified ollama model is available locally.
#
# Usage:
#   laptop_ollama_ensure_model <model_name>
#
# Example:
#   laptop_ollama_ensure_model llama2
#
laptop_ollama_ensure_model() {
  local model="$1"

  laptop_step_start "- Ensure ollama model '$model'"

  if ollama show "$model" &>/dev/null; then
    laptop_step_ok
  else
    laptop_step_eval "ollama pull $(quote "$model")"
  fi
}
