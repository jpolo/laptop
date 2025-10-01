#!/usr/bin/env bash

# Install asdf `package` if not present
#
# Usage:
#   laptop_asdf_ensure_package <package> <version> [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_asdf_ensure_package() {
  local package="$1"
  local version="${2:-latest}"
  # parse options
  local package_status="present"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--status) package_status="$2"; shift 2;;
      *) shift;;
    esac
  done

  laptop_step_start_status "$package_status" "asdf '$package' '$version'"
  if [ "$package_status" = "present" ]; then
    if ! asdf list "$package" 2>/dev/null | grep -Fq "$version"; then
      laptop_step_exec \
        asdf install "$package" "$version" &&
        asdf set --home "$package" "$version"
    else
      laptop_step_exec \
        asdf set --home "$package" "$version"
    fi
  else
    laptop_step_exec \
      asdf uninstall "$package" "$version"
  fi
}
