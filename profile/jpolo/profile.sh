# Bootstrap
laptop::bootstrap
laptop::ensure_file_template "resource/profile" "$HOME/.profile"
laptop::ensure_file_template "resource/zprofile" "$HOME/.zprofile"
laptop::ensure_file_template "resource/zshrc" "$HOME/.zshrc"
# for backward compatibility
laptop::ensure_file_template "resource/bash_profile" "$HOME/.bash_profile"

# Installation
laptop::exec_shell zsh "$LAPTOP_PROFILE_CURRENT_DIR/0-configure-shell.zsh"
laptop::exec_shell zsh "$LAPTOP_PROFILE_CURRENT_DIR/1-configure-all.zsh"

laptop::info "🎉 Finished"
laptop::info "$(cat << EOF
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
