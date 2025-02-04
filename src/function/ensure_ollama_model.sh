#!/usr/bin/env bash

# Ensure the specified ollama model is available locally.
#
# Usage:
#   laptop::ensure_ollama_model <model_name>
#
# Example:
#   laptop::ensure_ollama_model llama2
#
laptop::ensure_ollama_model() {
  local model="$1"

  laptop::step_start "- Ensure ollama model '$model'"

  if ollama show "$model" &>/dev/null; then
    laptop::step_ok
  else
    laptop::step_eval "ollama pull $(quote "$model")"
  fi
}
