#!/usr/bin/env bash

# Profile privacy settings
LAPTOP_PROFILE_PRIVACY="${LAPTOP_PROFILE_PRIVACY:-strict}"

# Bootstrap
laptop_bootstrap
laptop_configure_default_shell

# Installation
laptop_configure_steps

laptop_info "🎉 Finished"
laptop_info "$(
  cat <<EOF
  What next ?

  1️⃣ Finish your configuration manually :
    ZSH :
      🔧 Customize your configuration
         > $EDITOR $XDG_DATA_HOME/zsh/personal.sh

      🎨 Customize the zsh prompt theme
         > $EDITOR $STARSHIP_CONFIG

  2️⃣ Start developing !
    ⤵️ Clone your repositories in ~/Code
    📸 Manage your Capture in ~/Captures
EOF
)"
laptop_warn "ZSH configuration was potentially modified, please close/open a new terminal to see changes."
