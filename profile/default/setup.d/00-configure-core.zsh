#!/usr/bin/env zsh

laptop_package_ensure "config:os-recommended"

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
  laptop_package_ensure "config:git-recommended"
fi

# Configure ssh
if [ "$LAPTOP_DEVCONTAINER" = "false" ];then
  # Configure ssh
  laptop_package_ensure "config:ssh-recommended"
fi
