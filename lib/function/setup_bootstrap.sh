#!/usr/bin/env bash

laptop_require "laptop_die"

laptop_setup_bootstrap_debian() {
  laptop_require "laptop_apt_ensure_updated"
  laptop_require "laptop_apt_ensure_package"
  laptop_require "laptop_shell_ensure"
  laptop_require "laptop_package_ensure"

  laptop_apt_ensure_updated
  laptop_apt_ensure_package "zsh"
  laptop_shell_ensure "$LAPTOP_SHELL"
  laptop_package_ensure "pack:apt-core"
  laptop_package_ensure "brew"
  # set laptop package manager
  export LAPTOP_PACKAGE_MANAGER=brew
  laptop_apt_ensure_package "augeas-tools"
}

laptop_setup_bootstrap_macos() {
  laptop_require "laptop_package_ensure"
  laptop_require "laptop_xcode_ensure_license_accepted"
  laptop_require "laptop_shell_ensure"
  laptop_require "laptop_brew_ensure_package"

  laptop_package_ensure "rosetta2"
  laptop_package_ensure "xcode-command-line-tools"
  laptop_xcode_ensure_license_accepted
  laptop_shell_ensure "$LAPTOP_SHELL"
  laptop_package_ensure "brew"
  # set laptop package manager
  export LAPTOP_PACKAGE_MANAGER=brew
  laptop_brew_ensure_package "augeas"
}

laptop_setup_bootstrap() {
  if command -v apt-get &>/dev/null; then
    laptop_setup_bootstrap_debian
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    laptop_setup_bootstrap_macos
  else
    laptop_die "Unsupported OS. Only debian based and macos is supported."
  fi
  # Install brew package if LAPTOP_INSTALL_BREW_PACKAGE is set
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ] && [ -n "$LAPTOP_INSTALL_BREW_PACKAGE" ]; then
    laptop_brew_ensure_package "$LAPTOP_INSTALL_BREW_PACKAGE" --HEAD
  fi
}
