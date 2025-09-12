#!/usr/bin/env bash

laptop_ensure_vscode_updated() {
  laptop_step_start "- Upgrade VSCode"
  laptop_step_eval "code --update-extensions"
}
