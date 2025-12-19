#!/usr/bin/env zsh

# Ensure Code
laptop_directory_ensure "$HOME/Code"
laptop_directory_ensure "$HOME/Captures"

if laptop_command_exists "defaults"; then
  laptop_package_ensure "config:macos-global-recommended"
  laptop_package_ensure "config:macos-screencapture-recommended"
  laptop_package_ensure "config:macos-update-recommended"
fi

# Install standard utils
laptop_package_ensure "pack:core"
laptop_package_ensure "config:asdf-recommended"
laptop_package_ensure "pack:cli-tools"
laptop_package_ensure "pack:kube-utils"
laptop_package_ensure "pack:cloud-utils"

if [ "$LAPTOP_DEVCONTAINER" = "false" ];then
  # Configure git
  laptop_file_ensure "$(laptop_xdg_dir "config")/git/config"
  laptop_package_ensure "config:git-recommended"
  # Configure github
  laptop_github_ensure_login
  # Configure ssh
  laptop_package_ensure "config:ssh-recommended"
  laptop_ssh_ensure_key "ed25519"
  laptop_ssh_ensure_setting "Host *" "IdentityFile" "~/.ssh/id_ed25519"
fi

laptop_package_ensure "profile:core"

# Install programs (non devcontainers only)
if [ "$LAPTOP_DEVCONTAINER" = "false" ];then
  laptop_package_ensure "pack:social"
  laptop_package_ensure "pack:security"
  laptop_package_ensure "pack:productivity"
  laptop_package_ensure "pack:media"
  laptop_package_ensure "pack:development"
  laptop_package_ensure "pack:proton"

  laptop_ollama_ensure_model "qwen2.5-coder:1.5b"
  laptop_ollama_ensure_model "nomic-embed-text"
  laptop_package_ensure "orbstack"
  laptop_package_ensure "container"

  laptop_package_ensure "mongodb-database-tools"

  # Install programs
  laptop_package_ensure "android-studio"
  laptop_package_ensure "android-sdk"

  # laptop_package_ensure "idb-companion" # deprecated method
  # laptop_package_ensure "flipper" # deprecated method

  # Install VSCode extensions
  laptop_package_ensure "pack:vscode-extension-recommended"
  laptop_package_ensure "profile:vscode-extensions"

  # Configure VSCode
  laptop_package_ensure "config:vscode-recommended"
  laptop_vscode_ensure_setting '["editor.fontFamily"]' "\"'Monaspace Neon', Menlo, Monaco, Courier New, monospace\""
  laptop_vscode_ensure_setting '["editor.fontLigatures"]' "\"'calt', 'liga', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09'\""

  # Fix ruby lsp with asdf
  laptop_vscode_ensure_setting '["rubyLsp.rubyVersionManager","identifier"]' '"asdf"'
fi


