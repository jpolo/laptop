#!/usr/bin/env zsh

source "$LAPTOP_HOME/src/env.sh"

# Ensure Code
laptop_ensure_directory "$HOME/Code"
laptop_ensure_directory "$HOME/Captures"

# Default settings
laptop_ensure_defaults NSGlobalDomain AppleShowAllExtensions -bool false
laptop_ensure_defaults NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
laptop_ensure_defaults NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
laptop_ensure_defaults NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
laptop_ensure_defaults NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
laptop_ensure_defaults NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
laptop_ensure_defaults NSGlobalDomain NSAutomaticTextCompletionEnabled -bool false
# Set sidebar icon size
laptop_ensure_defaults NSGlobalDomain NSTableViewDefaultSizeMode -int 3

## Screen Capture application
laptop_ensure_defaults com.apple.screencapture location -string "$HOME/Captures"
# Save PNG format
laptop_ensure_defaults com.apple.screencapture type -string "png"

# Software updates

# Enable the automatic update check
laptop_ensure_defaults com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
# Download newly available updates in background
laptop_ensure_defaults com.apple.SoftwareUpdate AutomaticDownload -int 1
# Install System data files & security updates
laptop_ensure_defaults com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
# Automatically download apps purchased on other Macs
laptop_ensure_defaults com.apple.SoftwareUpdate ConfigDataInstall -int 1
# Turn on app auto-update
laptop_ensure_defaults com.apple.commerce AutoUpdate -bool true

killall Finder

# laptop_ensure_defaults_bool "/Library/Preferences/com.apple.commerce.plist" AutoUpdate -bool false

# Install standard utils
laptop_ensure_package "pack:core"
laptop_ensure_package "pack:cli-tools"

if [ -z "$LAPTOP_DEVCONTAINER" ];then
  # Configure git
  laptop_ensure_file "$XDG_CONFIG_HOME/git/config"
  laptop_ensure_git_config "core.ignorecase" "false"
  laptop_ensure_git_config "init.defaultBranch" "main"
  # https://pawelgrzybek.com/auto-setup-remote-branch-and-never-again-see-an-error-about-the-missing-upstream/
  laptop_ensure_git_config "push.default" "current"
  laptop_ensure_git_config "push.autoSetupRemote" "true"
  laptop_ensure_git_config "fetch.prune" "true"
  laptop_ensure_git_config "user.email"
  laptop_ensure_git_config "user.name"
  laptop_ensure_github_login
  laptop_ensure_ssh_directory
  laptop_ensure_ssh_key "ed25519"
fi

# Install globally tools using asdf to the version specified in profile/${profile_name}/.tool-versions
laptop_ensure_asdf_package_list "$(laptop_profile_dir)/.tool-versions"

# Install programs (non devcontainers only)
if [ -z "$LAPTOP_DEVCONTAINER" ];then
  laptop_ensure_package "pack:social"
  laptop_ensure_package "pack:security"
  laptop_ensure_package "pack:productivity"
  laptop_ensure_package "pack:media"
  laptop_ensure_package "pack:development"
  laptop_ensure_package "pack:proton"

  laptop_ensure_ollama_model "qwen2.5-coder:1.5b"
  laptop_ensure_ollama_model "nomic-embed-text"
  laptop_ensure_package "orbstack"

  laptop_ensure_package "mongodb-community"
  laptop_ensure_package "mongodb-database-tools"

  # Install programs
  laptop_ensure_package "android-studio"
  laptop_ensure_package "android-sdk"

  # Install devops / cloud provider
  laptop_ensure_package "az"
  laptop_ensure_package "heroku"
  laptop_ensure_package "gcloud"
  laptop_ensure_package "k9s"
  laptop_ensure_package "kubectl"
  laptop_ensure_package "kubectx"
  laptop_ensure_package "scalingo"

  # laptop_ensure_package "idb-companion" # deprecated method
  # laptop_ensure_package "flipper" # deprecated method


  # Install VSCode extensions
  laptop_ensure_vscode_extension "EditorConfig.EditorConfig"
  laptop_ensure_vscode_extension "eamodio.gitlens"
  laptop_ensure_vscode_extension "GitHub.vscode-pull-request-github"
  laptop_ensure_vscode_extension "ms-vsliveshare.vsliveshare"
  laptop_ensure_vscode_extension "joshbolduc.commitlint"
  laptop_ensure_vscode_extension "streetsidesoftware.code-spell-checker"
  laptop_ensure_vscode_extension "seatonjiang.gitmoji-vscode"
  laptop_ensure_vscode_extension "redhat.vscode-yaml"
  laptop_ensure_vscode_extension "aaron-bond.better-comments"
  laptop_ensure_vscode_extension "tamasfe.even-better-toml"

  # Configure VSCode
  laptop_ensure_npm_package "jsonc-cli"
  laptop_ensure_vscode_setting '["workbench.fontAliasing"]' '"auto"'
  laptop_ensure_vscode_setting '["editor.bracketPairColorization.enabled"]' 'true'
  laptop_ensure_vscode_setting '["editor.fontFamily"]' "\"'Monaspace Neon', Menlo, Monaco, Courier New, monospace\""
  laptop_ensure_vscode_setting '["editor.fontLigatures"]' "\"'calt', 'liga', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09'\""
  laptop_ensure_vscode_setting '["git.confirmSync"]' 'false'
  laptop_ensure_vscode_setting '["git.autofetch"]' 'true'
  # Important settings to disable
  laptop_ensure_vscode_setting '["files.insertFinalNewline"]' ''
  laptop_ensure_vscode_setting '["files.trimFinalNewlines"]' ''
  laptop_ensure_vscode_setting '["files.trimTrailingWhitespace"]' ''
  laptop_ensure_vscode_setting '["editor.trimAutoWhitespace"]' ''
  laptop_ensure_vscode_setting '["editor.tabSize"]' ''
  laptop_ensure_vscode_setting '["window.commandCenter"]' 'true'
  # Fix ruby lsp with asdf
  laptop_ensure_vscode_setting '["rubyLsp.rubyVersionManager","identifier"]' '"asdf"'
  # Disable gitlens pro features annoying messages
  laptop_ensure_vscode_setting '["gitlens.plusFeatures.enabled"]' 'false'
fi

laptop_ssh_key_test "git@github.com" \
  && laptop_info "🔑✅ SSH valid on github.com." \
  || laptop_warn "🔑❌ SSH invalid on github.com. Please register on https://github.com/settings/keys"

