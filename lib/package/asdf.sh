#!/usr/bin/env bash

laptop_require "laptop_package_ensure_default"
laptop_require "laptop_directory_ensure"
laptop_require "laptop_step_start"
laptop_require "laptop_step_exec"
laptop_require "laptop_step_status"
laptop_require "laptop_xdg_dir"

laptop_package_ensure__asdf() {
  local asdf_dir
  asdf_dir="${ASDF_DIR:-$HOME/.asdf}"
  local asdf_data_dir
  asdf_data_dir="${ASDF_DATA_DIR:-$(laptop_xdg_dir data)/asdf}"
  local target_status="present"
  local args=("$@")
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -s | --status)
      target_status="$2"
      shift 2
      ;;
    *) shift ;;
    esac
  done

  if [ "$target_status" = "absent" ]; then
    if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
      laptop_package_ensure_default "${args[@]}"
    fi

    local dirs=()
    [ -n "$asdf_dir" ] && dirs+=("$asdf_dir")
    if [ -n "$asdf_data_dir" ] && [ "$asdf_data_dir" != "$asdf_dir" ]; then
      dirs+=("$asdf_data_dir")
    fi

    local dir
    for dir in "${dirs[@]}"; do
      laptop_directory_ensure "$dir" --status absent
    done
    return 0
  fi

  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_brew_ensure_package "pkg-config"
    # unlink pkg-config on linux to avoid conflicts
    if [[ "$OSTYPE" != "darwin"* ]]; then
      laptop_brew_ensure_link "pkg-config" --status absent
    fi
    laptop_package_ensure_default "${args[@]}"
  else
    if [ ! -d "$asdf_dir" ]; then
      laptop_step_start "- Ensure asdf installed (via git)"
      laptop_step_exec git clone https://github.com/asdf-vm/asdf.git "$asdf_dir" --branch v0.14.0
      # shellcheck disable=SC1091
      source "$asdf_dir/asdf.sh"
    else
      laptop_step_status "ok"
    fi
  fi
}
