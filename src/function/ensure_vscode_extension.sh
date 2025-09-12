#!/usr/bin/env bash

laptop_ensure_vscode_extension() {
  local extension_name="$1"
  local list_extensions
  list_extensions=$(code --list-extensions)
  laptop_step_start "- Ensure VSCode '$extension_name'"

  if echo "$list_extensions" | grep -q "$extension_name"; then
    laptop_step_ok
  else
    laptop_step_exec code --install-extension "$extension_name" --force
  fi
}
