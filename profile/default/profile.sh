#!/usr/bin/env bash

LAPTOP_PROFILE_DEFAULT_DIR=$(laptop::profile_dir default)
# shellcheck disable=SC2034
LAPTOP_PROFILE_CURRENT_DIR=$(laptop::profile_dir)
# Profile privacy settings
LAPTOP_PROFILE_PRIVACY="${LAPTOP_PROFILE_PRIVACY:-strict}"

# Bootstrap
laptop::configure_default_shell

# Installation
laptop::exec_shell zsh "$LAPTOP_PROFILE_DEFAULT_DIR/0-configure-shell.zsh"
laptop::exec_shell zsh "$LAPTOP_PROFILE_DEFAULT_DIR/1-configure-all.zsh"

laptop::info "🎉 Finished"
laptop::info "$(
  cat <<EOF
  What next ?

  1️⃣ Finish your configuration manually :
    ZSH :
      🔧 Customize your configuration in \$XDG_DATA_HOME/zsh/personal.sh ($XDG_DATA_HOME/zsh/personal.sh)
      🎨 Customize the zsh prompt theme with "$EDITOR $STARSHIP_CONFIG"
  2️⃣ Start developing !
    ⤵️ Clone your repositories in ~/Code
    📸 Manage your Capture in ~/Captures
EOF
)"
laptop::warn "ZSH configuration was potentially modified, please close/open a new terminal to see changes."
