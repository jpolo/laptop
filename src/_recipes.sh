#!/usr/bin/env bash

# Load everything in recipes/
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
for f in "$SCRIPT_DIR/recipes/"*; do source $f; done

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

ensure_package__rosetta2() {
  # Install Rosetta
  _laptop_step_start "- Ensure Rosetta 2"
  if ! is_arm; then
    _laptop_step_pass
  elif ! command_exists "softwareupdate"; then
    _laptop_step_pass
  elif ! test -f /Library/Apple/usr/share/rosetta/rosetta; then
    _laptop_step_exec sudo softwareupdate --install-rosetta  --agree-to-license
  else
    _laptop_step_ok
  fi
}

