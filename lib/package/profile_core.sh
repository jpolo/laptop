#!/usr/bin/env bash

laptop_require "laptop_npm_ensure_package_list"
laptop_require "laptop_tool_manager"
laptop_require "laptop_die"

laptop_package_ensure__profile:core() {
  local profile_dir
  profile_dir="$(laptop_profile_dir)"
  local tool_manager
  tool_manager="$(laptop_tool_manager)"

  # Install profile tools from .tool-versions, preferring mise and retaining asdf compatibility.
  if [ "$tool_manager" = "mise" ]; then
    laptop_require "laptop_mise_ensure_package_list"
    laptop_mise_ensure_package_list "$profile_dir/.tool-versions" || return 1
  elif [ "$tool_manager" = "asdf" ]; then
    laptop_require "laptop_asdf_ensure_package_list"
    laptop_asdf_ensure_package_list "$profile_dir/.tool-versions" || return 1
  else
    laptop_die "No supported tool manager found; install mise or asdf and retry"
    return 1
  fi

  # Install npm packages
  laptop_npm_ensure_package_list "$profile_dir/npmfile"
}
