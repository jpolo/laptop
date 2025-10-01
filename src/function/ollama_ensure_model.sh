#!/usr/bin/env bash

# Ensure the specified ollama model is available locally.
#
# Usage:
#   laptop_ollama_ensure_model <model_name> [--status present|absent]
#
# Options:
#   --status present|absent
#
# Example:
#   laptop_ollama_ensure_model llama2
#
laptop_ollama_ensure_model() {
  local model="$1"
  local resource_status="present"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--status) resource_status="$2"; shift 2;;
      *) shift;;
    esac
  done
  laptop_step_start_status "$resource_status" "Ollama model '$model'"

  if [ "$resource_status" = "present" ]; then
    if ollama show "$model" &>/dev/null; then
      laptop_step_ok
    else
      laptop_step_eval "ollama pull $(quote "$model")"
    fi
  else
    if ollama show "$model" &>/dev/null; then
      laptop_step_eval "ollama rm $(quote "$model")"
    else
      laptop_step_ok
    fi
  fi
}
