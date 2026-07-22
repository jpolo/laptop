#!/usr/bin/env bash

laptop_require "laptop_git_ensure_config"

# Git settings for developers
laptop_package_ensure__config:git-recommended() {
  # Setup git config directory
  laptop_file_ensure "$(laptop_xdg_dir "config")/git/config"

  # Useful git settings
  laptop_git_ensure_config "core.ignorecase" "false"
  laptop_git_ensure_config "init.defaultBranch" "main"
  # https://pawelgrzybek.com/auto-setup-remote-branch-and-never-again-see-an-error-about-the-missing-upstream/
  laptop_git_ensure_config "push.default" "current"
  laptop_git_ensure_config "push.autoSetupRemote" "true"
  laptop_git_ensure_config "fetch.prune" "true"

  # User information
  laptop_git_ensure_config "user.email"
  laptop_git_ensure_config "user.name"
}
