#!/usr/bin/env bash

ensure_package__asdf() {
  local asdf_dir="${ASDF_DIR:-$HOME/.asdf}"
  if [ $LAPTOP_PACKAGE_MANAGER = "brew" ];then
    ensure_package_default "asdf"
  else
    if [ ! -d "$asdf_dir" ];then
      _laptop_step_start "- Ensure asdf installed (via git)"
      _laptop_step_eval "git clone https://github.com/asdf-vm/asdf.git $asdf_dir --branch v0.12.0"
      source "$asdf_dir/asdf.sh"
    else 
      _laptop_step_ok
    fi
  fi
}

ensure_package__gnutls() {
  if [ $LAPTOP_PACKAGE_MANAGER = "brew" ];then
    ensure_package_default "gnutls"
  else
    ensure_package_default "gnutls-bin"
  fi
}

ensure_package__libpq() {
  if [ $LAPTOP_PACKAGE_MANAGER = "brew" ];then
    ensure_package_default "libpq"
  else
    ensure_package_default "libpq-dev"
  fi
}

ensure_package__libyaml() {
  if [ $LAPTOP_PACKAGE_MANAGER = "brew" ];then
    ensure_package_default "libyaml"
  else
    ensure_package_default "libyaml-dev"
  fi
}

ensure_package__libvips() {
  if [ $LAPTOP_PACKAGE_MANAGER = "brew" ];then
    ensure_package_default "vips"
  else
    ensure_package_default "libvips-dev"
  fi
}
