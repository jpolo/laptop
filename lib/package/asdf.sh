#!/usr/bin/env bash

laptop_require "laptop_package_ensure_default"
laptop_require "laptop_step_start"
laptop_require "laptop_step_eval"
laptop_require "laptop_step_status"

laptop_package_ensure__asdf() {
  local asdf_dir
  asdf_dir="${ASDF_DIR:-$HOME/.asdf}"
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_brew_ensure_package "pkg-config"
    # unlink pkg-config on linux to avoid conflicts
    if [[ "$OSTYPE" != "darwin"* ]]; then
      laptop_brew_ensure_link "pkg-config" --status absent
    fi
    laptop_package_ensure_default "asdf"
  else
    if [ ! -d "$asdf_dir" ]; then
      laptop_step_start "- Ensure asdf installed (via git)"
      laptop_step_eval "git clone https://github.com/asdf-vm/asdf.git $asdf_dir --branch v0.14.0"
      # shellcheck disable=SC1091
      source "$asdf_dir/asdf.sh"
    else
      laptop_step_status "ok"
    fi
  fi
}
