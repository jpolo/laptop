#!/usr/bin/env bash

laptop_bootstrap_debian() {
  laptop_apt_ensure_updated
  laptop_apt_ensure_package "zsh"
  laptop_shell_ensure "$LAPTOP_SHELL"
  laptop_package_ensure "pack:apt-core"
  laptop_package_ensure "brew"
  # set laptop package manager
  export LAPTOP_PACKAGE_MANAGER=brew
}

laptop_bootstrap_macos() {
  laptop_package_ensure "rosetta2"
  laptop_package_ensure "xcode-command-line-tools"
  laptop_xcode_ensure_license_accepted
  laptop_shell_ensure "$LAPTOP_SHELL"
  laptop_package_ensure "brew"
  # set laptop package manager
  export LAPTOP_PACKAGE_MANAGER=brew
}

laptop_bootstrap() {
  if command -v apt-get &>/dev/null; then
    laptop_bootstrap_debian
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    laptop_bootstrap_macos
  else
    laptop_die "Unsupported OS. Only debian based and macos is supported."
  fi
}
