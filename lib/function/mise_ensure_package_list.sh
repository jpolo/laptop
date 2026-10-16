#!/usr/bin/env bash

laptop_require "laptop_mise_ensure_package"
laptop_require "laptop_log"

# Install and select tools listed in a .tool-versions file using mise.
laptop_mise_ensure_package_list() {
  local tool_version_file="$1"
  local line
  local target_package
  local target_version

  if [[ ! -f "$tool_version_file" ]]; then
    laptop_log warn "$tool_version_file does not exist"
    return 0
  fi

  while IFS= read -r line || [[ -n "$line" ]]; do
    read -r target_package target_version <<<"$line"
    [[ -z "$target_package" || "$target_package" == \#* ]] && continue

    if [[ -z "$target_version" ]]; then
      laptop_log error "Missing version for '$target_package' in $tool_version_file"
      return 1
    fi

    # mise uses "node" where asdf's .tool-versions uses "nodejs".
    if [[ "$target_package" == "nodejs" ]]; then
      target_package="node"
    fi

    laptop_mise_ensure_package "$target_package" "$target_version" || return 1
  done <"$tool_version_file"
}
