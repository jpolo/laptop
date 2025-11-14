#!/usr/bin/env bash

laptop_package_ensure__pack:cli-tools() {
  # A pack of useful tools
  laptop_package_ensure "adr-tools"

  laptop_package_ensure "gitmoji"
  # laptop_package_ensure "google-cloud-sdk" -> TODO: Change method to use asdf install
  laptop_package_ensure "pv"
  laptop_package_ensure "tmux"
  laptop_package_ensure "tree"
  laptop_package_ensure "fzf"
  laptop_package_ensure "gh"
  laptop_package_ensure "sops"
  laptop_package_ensure "starship"
  laptop_package_ensure "watchman"
  # laptop_package_ensure "trash"
  laptop_package_ensure "universal-ctags"
  # laptop_package_ensure "xeol"
  laptop_package_ensure "yq"
}
