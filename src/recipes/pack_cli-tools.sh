#!/usr/bin/env bash

laptop_ensure_package__pack:cli-tools() {
  # A pack of useful tools
  laptop_ensure_package "adr-tools"

  laptop_ensure_package "gitmoji"
  # laptop_ensure_package "google-cloud-sdk" -> TODO: Change method to use asdf install
  laptop_ensure_package "pv"
  laptop_ensure_package "tmux"
  laptop_ensure_package "tree"
  laptop_ensure_package "fzf"
  laptop_ensure_package "gh"
  laptop_ensure_package "sops"
  laptop_ensure_package "starship"
  laptop_ensure_package "watchman"
  # laptop_ensure_package "trash"
  laptop_ensure_package "universal-ctags"
  # laptop_ensure_package "xeol"
  laptop_ensure_package "yq"
}
