#!/usr/bin/env bash

laptop::ensure_package__pack:cli-tools() {
  # A pack of useful tools
  laptop::ensure_package "adr-tools"

  laptop::ensure_package "gitmoji"
  laptop::ensure_package "google-cloud-sdk"
  laptop::ensure_package "heroku"
  laptop::ensure_package "kubectl"
  laptop::ensure_package "pv"
  laptop::ensure_package "tmux"
  laptop::ensure_package "tree"
  laptop::ensure_package "fzf"
  laptop::ensure_package "gh"
  laptop::ensure_package "watchman"
  # laptop::ensure_package "trash"
  laptop::ensure_package "universal-ctags"
  laptop::ensure_package "xeol"
  laptop::ensure_package "yq"
}
