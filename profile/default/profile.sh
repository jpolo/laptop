#!/usr/bin/env bash

LAPTOP_PROFILE_DEFAULT_DIR=$(laptop::profile_dir default)
# shellcheck disable=SC2034
LAPTOP_PROFILE_CURRENT_DIR=$(laptop::profile_dir)
# Profile privacy settings
LAPTOP_PROFILE_PRIVACY="${LAPTOP_PROFILE_PRIVACY:-strict}"

# Bootstrap
laptop::bootstrap
laptop::ensure_file_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/profile" "$HOME/.profile"
laptop::set_user_profile "LAPTOP_PROFILE" "${LAPTOP_PROFILE}"
laptop::set_user_profile "LAPTOP_GIT_REMOTE" "${LAPTOP_GIT_REMOTE}"

laptop::ensure_file_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/zprofile" "$HOME/.zprofile"
laptop::ensure_file_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/zshrc" "$HOME/.zshrc"
# for backward compatibility
laptop::ensure_file_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/bash_profile" "$HOME/.bash_profile"

# Installation
laptop::exec_shell zsh "$LAPTOP_PROFILE_DEFAULT_DIR/0-configure-shell.zsh"
laptop::exec_shell zsh "$LAPTOP_PROFILE_DEFAULT_DIR/1-configure-all.zsh"

laptop::info "🎉 Finished"
laptop::info "$(
  cat <<EOF
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
laptop::warn "ZSH configuration was potentially modified, please close/open a new terminal to see changes."
