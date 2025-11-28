#!/usr/bin/env zsh

laptop_ssh_test_key "git@github.com" \
  && laptop_info "🔑✅ SSH valid on github.com." \
  || laptop_warn "🔑❌ SSH invalid on github.com. Please register on https://github.com/settings/keys"

laptop_info "🎉 Finished"
laptop_info "$(
  cat <<EOF
  What next ?

  1️⃣ Finish your configuration manually :
    ZSH :
      🔧 Customize your zsh configuration
         > laptop config zsh --edit

      🎨 Customize the zsh prompt theme
         > laptop config starship --edit

  2️⃣ Start developing !
    ⤵️ Clone your repositories in ~/Code
    📸 Manage your Capture in ~/Captures
EOF
)"
laptop_warn "ZSH configuration was potentially modified, please close/open a new terminal to see changes."
