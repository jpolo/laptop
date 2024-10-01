#!/usr/bin/env bash

ensure_package__pack:utils() {
  # A pack of useful tools
  ensure_package "adr-tools"
  ensure_package "gitmoji"
  ensure_package "google-cloud-sdk"
  ensure_package "heroku"
  ensure_package "kubectl"
  ensure_package "pv"
  ensure_package "tmux"
  ensure_package "tree"
  ensure_package "fzf"
  ensure_package "gh"
  ensure_package "watchman"
  # ensure_package "trash"
  ensure_package "universal-ctags"
  ensure_package "yq"
}
