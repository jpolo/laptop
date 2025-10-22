#!/usr/bin/env bash

laptop_package_ensure__profile:core() {
  local profile_dir
  profile_dir="$(laptop_profile_dir)"

  # Install globally tools using asdf to the version specified in profile/${profile_name}/.tool-versions
  laptop_asdf_ensure_package_list "$profile_dir/.tool-versions"

  # Install npm packages
  laptop_npm_ensure_package_list "$profile_dir/npmfile"
}
