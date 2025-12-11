#!/usr/bin/env bash

laptop_require "laptop_log"

# Display a finished step
#
# Usage:
#   laptop_step_finished <message>
#
laptop_step_finished() {
  laptop_log info "🎉 Finished"
  laptop_log info "$(
  cat <<EOF
  What next ?

  1️⃣ If you want to customize your configuration :
    🛟 Show overall help
      > laptop --help

    ⚙️ Show help for configuration
      > laptop config --help

  2️⃣ Start using your laptop !
    ⤵️ Clone your repositories in ~/Code
    📸 Manage your Capture in ~/Captures
EOF
)"
  laptop_log warn "ZSH configuration was potentially modified, please close/open a new terminal to see changes."
}
