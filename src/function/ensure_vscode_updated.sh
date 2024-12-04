#!/usr/bin/env bash

laptop::ensure_vscode_updated() {
  laptop::step_start "- Upgrade VSCode"
  laptop::step_eval "code --update-extensions"
}
