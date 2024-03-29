#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/_functions.sh"

# Bootstrap
_laptop_bootstrap
ensure_file_template "zprofile" "$HOME/.zprofile"
ensure_file_template "zshrc" "$HOME/.zshrc"

# Installation
_laptop_shell zsh "$LAPTOP_SOURCE_DIR/0-configure-shell.zsh"
_laptop_shell zsh "$LAPTOP_SOURCE_DIR/1-configure-all.zsh"

einfo "🎉 Finished"
einfo "$(cat << EOF
What next ?

1️⃣ Finish your configuration manually :
  Git :
    🔑 Authorize your SSH key in your git server
      - Github : https://github.com/settings/keys
      - Gitlab : https://gitlab.com/-/profile/keys
      - Gitlab Self Hosted
  ZSH :
    🔧 Customize your configuration in \$XDG_DATA_HOME/zsh/personal.sh ($XDG_DATA_HOME/zsh/personal.sh)
    🎨 Customize the zsh prompt theme with "p10k configure"
2️⃣ Start developing !
  ⤵️ Clone your repositories in ~/Code
  📸 Manage your Capture in ~/Captures
EOF
)"
ewarn "ZSH configuration was potentially modified, please close/open a new terminal to see changes."
