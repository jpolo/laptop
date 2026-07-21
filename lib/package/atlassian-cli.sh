#!/usr/bin/env bash

laptop_require "laptop_brew_ensure_package"
laptop_require "laptop_apt_ensure_package"
laptop_require "laptop_apt_ensure_keyring"
laptop_require "laptop_apt_ensure_repository"

laptop_package_ensure__atlassian-cli() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    # Atlassian CLI
    laptop_brew_ensure_package "atlassian/homebrew-acli/acli" "$@"
  else

    local keyring_path="/etc/apt/keyrings/acli-archive-keyring.gpg"
    # Linux: set up official Atlassian APT repository, then install
    laptop_apt_ensure_keyring \
      "$keyring_path" \
      "https://acli.atlassian.com/gpg/public-key.asc"

    laptop_apt_ensure_repository \
      "https://acli.atlassian.com/linux/deb stable main" \
      --keyring-path "$keyring_path" \
      --sources-list "/etc/apt/sources.list.d/acli.list"

    laptop_apt_ensure_package "acli" "$@"
  fi
}
