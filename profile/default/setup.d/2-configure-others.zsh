#!/usr/bin/env zsh

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


