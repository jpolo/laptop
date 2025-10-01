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
  local current_package_status
  current_package_status=$(asdf list "$package" 2>/dev/null | grep -Fq "$version" && echo "present" || echo "absent")
  local message="asdf '$package' '$version'"

  if [ "$current_package_status" = "$package_status" ]; then
    laptop_step_start_status "unchanged" "$message"
    laptop_step_ok
  else
    laptop_step_start_status "$package_status" "$message"
    if [ "$package_status" = "present" ]; then
      laptop_step_exec \
        asdf install "$package" "$version" &&
        asdf set --home "$package" "$version"
    else
      laptop_step_exec \
        asdf set --home "$package" "$version"
    fi
  fi
}
