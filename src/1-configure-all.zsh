#!/usr/bin/env zsh

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/_functions.sh"
source "$SCRIPT_DIR/_recipes.sh"

# Ensure Code
ensure_directory "$HOME/Code"
ensure_directory "$HOME/Captures"

# Default settings
ensure_defaults NSGlobalDomain AppleShowAllExtensions -bool false
ensure_defaults NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
ensure_defaults NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
ensure_defaults NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
ensure_defaults NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
ensure_defaults NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
ensure_defaults NSGlobalDomain NSAutomaticTextCompletionEnabled -bool false
# Set sidebar icon size
ensure_defaults NSGlobalDomain NSTableViewDefaultSizeMode -int 3

## Screen Capture application
ensure_defaults com.apple.screencapture location -string "$HOME/Captures"
# Save PNG format
ensure_defaults com.apple.screencapture type -string "png"

# Software updates

# Enable the automatic update check
ensure_defaults com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
# Download newly available updates in background
ensure_defaults com.apple.SoftwareUpdate AutomaticDownload -int 1
# Install System data files & security updates
ensure_defaults com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
# Automatically download apps purchased on other Macs
ensure_defaults com.apple.SoftwareUpdate ConfigDataInstall -int 1
# Turn on app auto-update
ensure_defaults com.apple.commerce AutoUpdate -bool true

killall Finder

# ensure_defaults_bool "/Library/Preferences/com.apple.commerce.plist" AutoUpdate -bool false

# Install standard utils
ensure_package "pack:core"
ensure_package "pack:utils"

if [ -z "$LAPTOP_DEVCONTAINER" ];then
  # Configure git
  ensure_file "$XDG_CONFIG_HOME/git/config"
  ensure_git_config "core.ignorecase" "false"
  # https://pawelgrzybek.com/auto-setup-remote-branch-and-never-again-see-an-error-about-the-missing-upstream/
  ensure_git_config "push.default" "current"
  ensure_git_config "push.autoSetupRemote" "true"
  ensure_git_config "fetch.prune" "true"
  ensure_git_config "user.email"
  ensure_git_config "user.name"
  ensure_ssh_key "ed25519"
fi

# Install ASDF plugins
ensure_asdf_plugin "java" "https://github.com/halcyon/asdf-java.git"
ensure_asdf_plugin "ruby" "https://github.com/asdf-vm/asdf-ruby.git"
ensure_asdf_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
ensure_asdf_plugin "python"

# Hashicorp
ensure_asdf_plugin "boundary" "https://github.com/asdf-community/asdf-hashicorp.git"
ensure_asdf_plugin "consul" "https://github.com/asdf-community/asdf-hashicorp.git"
ensure_asdf_plugin "levant" "https://github.com/asdf-community/asdf-hashicorp.git"
ensure_asdf_plugin "nomad" "https://github.com/asdf-community/asdf-hashicorp.git"
ensure_asdf_plugin "packer" "https://github.com/asdf-community/asdf-hashicorp.git"
ensure_asdf_plugin "sentinel" "https://github.com/asdf-community/asdf-hashicorp.git"
ensure_asdf_plugin "serf" "https://github.com/asdf-community/asdf-hashicorp.git"
ensure_asdf_plugin "terraform" "https://github.com/asdf-community/asdf-hashicorp.git"
ensure_asdf_plugin "terraform-ls" "https://github.com/asdf-community/asdf-hashicorp.git"
ensure_asdf_plugin "tfc-agent" "https://github.com/asdf-community/asdf-hashicorp.git"
ensure_asdf_plugin "vault" "https://github.com/asdf-community/asdf-hashicorp.git"
ensure_asdf_plugin "waypoint" "https://github.com/asdf-community/asdf-hashicorp.git"

ensure_asdf_plugin "kubectl" "https://github.com/asdf-community/asdf-kubectl.git"
ensure_asdf_plugin "kustomize" "https://github.com/Banno/asdf-kustomize.git"
ensure_asdf_plugin "cocoapods" "https://github.com/ronnnnn/asdf-cocoapods.git"


ensure_asdf_tool "ruby" "latest"
ensure_asdf_tool "nodejs" "latest"
ensure_asdf_tool "java" "adoptopenjdk-17.0.6+10"
ensure_asdf_tool "terraform" "latest"


# Install programs (non devcontainers only)
if [ -z "$LAPTOP_DEVCONTAINER" ];then
  # Install programs
  ensure_package "android-studio"
  ensure_package "chromedriver"
  ensure_package "discord"
  ensure_package "docker"
  ensure_package "drawio"
  ensure_package "flipper"
  ensure_package "font-monaspace"
  ensure_package "google-chrome"
  ensure_package "google-drive"
  ensure_package "iterm2"
  ensure_package "macpass"
  ensure_package "notion"
  ensure_package "postman"
  ensure_package "rectangle"
  ensure_package "slack"
  # FIXME: Does not work on Apple Silicon M1, M2, etc
  # Error: Cask virtualbox depends on hardware architecture being one of [{:type=>:intel, :bits=>64}], but you are running {:type=>:arm, :bits=>64}.
  # ensure_package "virtualbox"
  ensure_package "visual-studio-code"

  # Install VSCode extensions
  ensure_vscode_extension "EditorConfig.EditorConfig"
  ensure_vscode_extension "eamodio.gitlens"
  ensure_vscode_extension "GitHub.vscode-pull-request-github"
  ensure_vscode_extension "GitLab.gitlab-workflow"
  ensure_vscode_extension "ms-vsliveshare.vsliveshare"
  ensure_vscode_extension "wayou.vscode-todo-highlight"
  ensure_vscode_extension "joshbolduc.commitlint"
  ensure_vscode_extension "streetsidesoftware.code-spell-checker"
  ensure_vscode_extension "seatonjiang.gitmoji-vscode"
  ensure_vscode_extension "redhat.vscode-yaml"

  # Configure VSCode
  ensure_npm_package "jsonc-cli"
  ensure_vscode_setting '["editor.bracketPairColorization.enabled"]' 'true'
  ensure_vscode_setting '["editor.fontFamily"]' '"\"Monaspace Neon\", Menlo, Monaco, Courier New, monospace"'
  ensure_vscode_setting '["editor.fontLigatures"]' 'true'
  ensure_vscode_setting '["git.confirmSync"]' 'false'
  ensure_vscode_setting '["git.autofetch"]' 'true'
  # Important settings to disable
  ensure_vscode_setting '["files.insertFinalNewline"]' ''
  ensure_vscode_setting '["files.trimFinalNewlines"]' ''
  ensure_vscode_setting '["files.trimTrailingWhitespace"]' ''
  ensure_vscode_setting '["editor.trimAutoWhitespace"]' ''
  ensure_vscode_setting '["editor.tabSize"]' ''
  ensure_vscode_setting '["window.commandCenter"]' 'true'
fi

test_ssh_key "git@github.com" || \
  ewarn "SSH invalid on github.com. Please register on https://github.com/settings/keys"

# Cleanup
_laptop_cleanup

