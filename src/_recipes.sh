#!/usr/bin/env bash

ensure_package__android-sdk() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    brew remove android-sdk &>/dev/null
    ensure_package_default "android-commandlinetools"
  else
    _laptop_step_start "- Ensure android-sdk installed (via git)"
    _laptop_step_eval "echo >&2 Not implemented;exit 1;"
  fi
}

ensure_package__asdf() {
  local asdf_dir="${ASDF_DIR:-$HOME/.asdf}"
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_package_default "asdf"
  else
    if [ ! -d "$asdf_dir" ];then
      _laptop_step_start "- Ensure asdf installed (via git)"
      _laptop_step_eval "git clone https://github.com/asdf-vm/asdf.git $asdf_dir --branch v0.14.0"
      source "$asdf_dir/asdf.sh"
    else
      _laptop_step_ok
    fi
  fi
}

ensure_package__gnutls() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_package_default "gnutls"
  else
    ensure_package_default "gnutls-bin"
  fi
}

ensure_package__heroku() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_brew_tap "heroku/brew"
    ensure_package_default "heroku"
  else
    ensure_package_default "heroku"
  fi
}

ensure_package__idb-companion() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_brew_tap "facebook/fb"
    ensure_package_default "idb-companion"
  else
    _laptop_step_start "- Ensure idb-companion installed (via git)"
    _laptop_step_pass
  fi
}

ensure_package__font-monaspace() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    # NOT required anymore
    # ensure_brew_tap "homebrew/cask-fonts"
    ensure_package_default "font-monaspace"
  else
    ensure_package_default "font-monaspace"
  fi
}

ensure_package__mongodb-community() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_brew_tap "mongodb/brew"
    ensure_package_default "mongodb-community@6.0"
  else
    ensure_package_default "mongodb-community"
  fi
}

ensure_package__mongodb-database-tools() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_brew_tap "mongodb/brew"
    ensure_package_default "mongodb-database-tools"
  else
    ensure_package_default "mongodb-database-tools"
  fi
}

ensure_package__libpq() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_package_default "libpq"
  else
    ensure_package_default "libpq-dev"
  fi
}

ensure_package__libyaml() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_package_default "libyaml"
  else
    ensure_package_default "libyaml-dev"
  fi
}

ensure_package__libvips() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_package_default "vips"
  else
    ensure_package_default "libvips-dev"
  fi
}

ensure_package__pack:core() {
  # A pack of required packages

  # Install core tools
  ensure_package "coreutils"
  ensure_package "moreutils"
  ensure_package "findutils"
  ensure_package "asdf"
  ensure_package "curl"
  ensure_package "git"
  ensure_package "gnutls"
  ensure_package "gnupg"
  ensure_package "mercurial"
  ensure_package "gpg"
  ensure_package "jq"
  ensure_package "rclone"
  ensure_package "webp"
  ensure_package "wget"
  ensure_package "yarn"

  # Install library
  ensure_package "graphviz"
  ensure_package "imagemagick"
  ensure_package "libpq"
  ensure_package "libyaml"
  ensure_package "libvips"
  ensure_package "openssl"
}

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

ensure_package__yarn() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_package_default "yarn"
  else
    ensure_apt_repository "https://dl.yarnpkg.com/debian/ stable main" "https://dl.yarnpkg.com/debian/pubkey.gpg"
    ensure_package_default "yarn"
  fi
}
