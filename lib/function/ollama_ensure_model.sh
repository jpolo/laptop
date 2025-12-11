#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_exec"
laptop_require "laptop_step_status"

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
    -s | --status)
      resource_status="$2"
      shift 2
      ;;
    *) shift ;;
    esac
  done

  local current_resource_status
  current_resource_status=$(ollama show "$model" &>/dev/null && echo "present" || echo "absent")
  laptop_step_start_status "$resource_status" "$current_resource_status" "Ollama model '$model'"

  if [ "$current_resource_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  else
    if [ "$resource_status" = "present" ]; then
      laptop_step_exec ollama pull "$model"
    else
      laptop_step_exec ollama rm "$model"
    fi
  fi
}
