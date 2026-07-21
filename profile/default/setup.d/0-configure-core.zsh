#!/usr/bin/env zsh

# Ensure Code
laptop_directory_ensure "$HOME/Code"
laptop_directory_ensure "$HOME/Captures"

if laptop_command_exists "defaults"; then
  laptop_package_ensure "config:macos-global-recommended"
  laptop_package_ensure "config:macos-screencapture-recommended"
  laptop_package_ensure "config:macos-update-recommended"
  laptop_package_ensure "config:macos-apps-recommended"
fi

# Install standard utils
laptop_package_ensure "pack:core"
laptop_package_ensure "config:asdf-recommended"
laptop_package_ensure "config:npm-recommended"
laptop_package_ensure "profile:core"
laptop_package_ensure "pack:cli-tools"
laptop_package_ensure "pack:kube-utils"
laptop_package_ensure "pack:cloud-utils"

# Configure git
if [ "$LAPTOP_DEVCONTAINER" = "false" ];then
  # Configure git
  laptop_file_ensure "$(laptop_xdg_dir "config")/git/config"
  laptop_package_ensure "config:git-recommended"
fi

# Configure ssh
if [ "$LAPTOP_DEVCONTAINER" = "false" ];then
  # Configure ssh
  laptop_package_ensure "config:ssh-recommended"
fi
