#!/usr/bin/env zsh

source "$LAPTOP_HOME/src/env.sh"

# Ensure Code
laptop::ensure_directory "$HOME/Code"
laptop::ensure_directory "$HOME/Captures"

# Default settings
laptop::ensure_defaults NSGlobalDomain AppleShowAllExtensions -bool false
laptop::ensure_defaults NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
laptop::ensure_defaults NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
laptop::ensure_defaults NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
laptop::ensure_defaults NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
laptop::ensure_defaults NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
laptop::ensure_defaults NSGlobalDomain NSAutomaticTextCompletionEnabled -bool false
# Set sidebar icon size
laptop::ensure_defaults NSGlobalDomain NSTableViewDefaultSizeMode -int 3

## Screen Capture application
laptop::ensure_defaults com.apple.screencapture location -string "$HOME/Captures"
# Save PNG format
laptop::ensure_defaults com.apple.screencapture type -string "png"

# Software updates

# Enable the automatic update check
laptop::ensure_defaults com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
# Download newly available updates in background
laptop::ensure_defaults com.apple.SoftwareUpdate AutomaticDownload -int 1
# Install System data files & security updates
laptop::ensure_defaults com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
# Automatically download apps purchased on other Macs
laptop::ensure_defaults com.apple.SoftwareUpdate ConfigDataInstall -int 1
# Turn on app auto-update
laptop::ensure_defaults com.apple.commerce AutoUpdate -bool true

killall Finder

# laptop::ensure_defaults_bool "/Library/Preferences/com.apple.commerce.plist" AutoUpdate -bool false

# Install standard utils
laptop::ensure_package "pack:core"
laptop::ensure_package "pack:cli-tools"

if [ -z "$LAPTOP_DEVCONTAINER" ];then
  # Configure git
  laptop::ensure_file "$XDG_CONFIG_HOME/git/config"
  laptop::ensure_git_config "core.ignorecase" "false"
  laptop::ensure_git_config "init.defaultBranch" "main"
  # https://pawelgrzybek.com/auto-setup-remote-branch-and-never-again-see-an-error-about-the-missing-upstream/
  laptop::ensure_git_config "push.default" "current"
  laptop::ensure_git_config "push.autoSetupRemote" "true"
  laptop::ensure_git_config "fetch.prune" "true"
  laptop::ensure_git_config "user.email"
  laptop::ensure_git_config "user.name"
  laptop::ensure_github_login
  laptop::ensure_ssh_directory
  laptop::ensure_ssh_key "ed25519"
fi

# Install globally tools using asdf to the version specified in profile/${profile_name}/.tool-versions
laptop::ensure_asdf_tool "ruby" "$(laptop::profile_asdf_version ruby)"
laptop::ensure_asdf_tool "nodejs" "$(laptop::profile_asdf_version nodejs)"
laptop::ensure_asdf_tool "python" "$(laptop::profile_asdf_version python)"
laptop::ensure_asdf_tool "java" "$(laptop::profile_asdf_version java)"
laptop::ensure_asdf_tool "terraform" "$(laptop::profile_asdf_version terraform)"


# Install programs (non devcontainers only)
if [ -z "$LAPTOP_DEVCONTAINER" ];then
  laptop::ensure_package "pack:social"
  laptop::ensure_package "pack:security"
  laptop::ensure_package "pack:productivity"
  laptop::ensure_package "pack:media"
  laptop::ensure_package "pack:development"
  laptop::ensure_package "pack:proton"

  # Install programs
  laptop::ensure_package "android-studio"
  laptop::ensure_package "android-sdk"

  # Install devops / cloud provider
  laptop::ensure_package "az"
  laptop::ensure_package "heroku"
  laptop::ensure_package "scalingo"

  # laptop::ensure_package "idb-companion" # deprecated method
  # laptop::ensure_package "flipper" # deprecated method


  # Install VSCode extensions
  laptop::ensure_vscode_extension "EditorConfig.EditorConfig"
  laptop::ensure_vscode_extension "eamodio.gitlens"
  laptop::ensure_vscode_extension "GitHub.vscode-pull-request-github"
  laptop::ensure_vscode_extension "GitLab.gitlab-workflow"
  laptop::ensure_vscode_extension "ms-vsliveshare.vsliveshare"
  laptop::ensure_vscode_extension "joshbolduc.commitlint"
  laptop::ensure_vscode_extension "streetsidesoftware.code-spell-checker"
  laptop::ensure_vscode_extension "seatonjiang.gitmoji-vscode"
  laptop::ensure_vscode_extension "redhat.vscode-yaml"
  laptop::ensure_vscode_extension "aaron-bond.better-comments"

  # Configure VSCode
  laptop::ensure_npm_package "jsonc-cli"
  laptop::ensure_vscode_setting '["editor.bracketPairColorization.enabled"]' 'true'
  laptop::ensure_vscode_setting '["editor.fontFamily"]' "\"'Monaspace Neon', Menlo, Monaco, Courier New, monospace\""
  laptop::ensure_vscode_setting '["editor.fontLigatures"]' "\"'calt', 'liga', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09'\""
  laptop::ensure_vscode_setting '["git.confirmSync"]' 'false'
  laptop::ensure_vscode_setting '["git.autofetch"]' 'true'
  # Important settings to disable
  laptop::ensure_vscode_setting '["files.insertFinalNewline"]' ''
  laptop::ensure_vscode_setting '["files.trimFinalNewlines"]' ''
  laptop::ensure_vscode_setting '["files.trimTrailingWhitespace"]' ''
  laptop::ensure_vscode_setting '["editor.trimAutoWhitespace"]' ''
  laptop::ensure_vscode_setting '["editor.tabSize"]' ''
  laptop::ensure_vscode_setting '["window.commandCenter"]' 'true'
  # Fix ruby lsp with asdf
  laptop::ensure_vscode_setting '["rubyLsp.rubyVersionManager","identifier"]' '"asdf"'
fi

laptop::ssh_key_test "git@github.com" \
  && laptop::info "🔑✅ SSH valid on github.com." \
  || laptop::warn "🔑❌ SSH invalid on github.com. Please register on https://github.com/settings/keys"

