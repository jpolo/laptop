#!/usr/bin/env zsh

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_functions.sh"

# Ensure Code
ensure_directory ~/Code

# Configure git
ensure_file "$XDG_CONFIG_HOME/git/config"

ensure_package "git"
# https://pawelgrzybek.com/auto-setup-remote-branch-and-never-again-see-an-error-about-the-missing-upstream/
ensure_git_config "push.default" "current"
ensure_git_config "push.autoSetupRemote" "true"
ensure_git_config "fetch.prune" "true"
ensure_git_config "user.email"
ensure_git_config "user.name"

ensure_ssh_key

# Default settings
ensure_defaults_bool "" AppleShowAllExtensions true
ensure_defaults_bool "" NSAutomaticCapitalizationEnabled false
ensure_defaults_bool "" NSAutomaticDashSubstitutionEnabled false
ensure_defaults_bool "" NSAutomaticPeriodSubstitutionEnabled false
ensure_defaults_bool "" NSAutomaticQuoteSubstitutionEnabled false
ensure_defaults_bool "" NSAutomaticSpellingCorrectionEnabled false
ensure_defaults_bool "" NSAutomaticTextCompletionEnabled false
# ensure_defaults_bool "/Library/Preferences/com.apple.commerce.plist" AutoUpdate false

# Install library
ensure_package "graphviz"
ensure_package "libpq"
ensure_package "libyaml"
ensure_package "openssl"
ensure_package "vips"

# Install programs
ensure_package "android-studio"
ensure_package "asdf"
ensure_package "chromedriver"
ensure_package "coreutils"
ensure_package "discord"
ensure_package "docker"
ensure_package "drawio"
ensure_package "flipper"
ensure_package "google-chrome"
ensure_package "google-drive"
ensure_package "gh"
ensure_package "gpg"
ensure_package "imagemagick"
ensure_package "iterm2"
ensure_package "jq"
ensure_package "macpass"
ensure_package "mercurial"
ensure_package "moreutils"
ensure_package "notion"
ensure_package "postman"
ensure_package "rectangle"
ensure_package "rclone"
ensure_package "slack"
ensure_package "tfenv"
# FIXME: Does not work on Apple Silicon M1, M2, etc
# Error: Cask virtualbox depends on hardware architecture being one of [{:type=>:intel, :bits=>64}], but you are running {:type=>:arm, :bits=>64}.
# ensure_package "virtualbox"
ensure_package "visual-studio-code"
ensure_package "universal-ctags"
ensure_package "watchman"
ensure_package "webp"
ensure_package "wget"
ensure_package "yarn"
ensure_package "yq"

# Install ASDF plugins
ensure_asdf_plugin "java" "https://github.com/halcyon/asdf-java.git"
ensure_asdf_plugin "ruby" "https://github.com/asdf-vm/asdf-ruby.git"
ensure_asdf_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
ensure_asdf_plugin "python"

ensure_asdf_language "ruby" "latest"
ensure_asdf_language "nodejs" "lts"
ensure_asdf_language "java" "adoptopenjdk-17.0.6+10"

# Install VSCode extensions
ensure_vscode_extension "EditorConfig.EditorConfig"
ensure_vscode_extension "eamodio.gitlens"
ensure_vscode_extension "GitHub.vscode-pull-request-github"
ensure_vscode_extension "GitLab.gitlab-workflow"
ensure_vscode_extension "ms-vsliveshare.vsliveshare"
ensure_vscode_extension "wayou.vscode-todo-highlight"

test_ssh_key "git@github.com" || \
  ewarn "SSH invalid on github.com. Please register on https://github.com/settings/keys"

