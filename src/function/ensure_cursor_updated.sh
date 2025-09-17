#!/usr/bin/env bash

laptop_ensure_vscode_updated() {
  laptop_step_start "- Upgrade Cursor"
  laptop_step_eval "cursor --update-extensions"
}
