#!/usr/bin/env bash

laptop_bootstrap_debian() {
  laptop_ensure_shell "$LAPTOP_SHELL"
  laptop_ensure_apt_updated
  laptop_ensure_package "pack:apt-core"
}

laptop_bootstrap_macos() {
  laptop_ensure_package "rosetta2"
  laptop_ensure_package "xcode-command-line-tools"
  laptop_ensure_shell "$LAPTOP_SHELL"
  laptop_ensure_package "brew"
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
