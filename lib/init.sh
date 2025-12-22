#!/usr/bin/env bash

# shellcheck disable=SC2155
if [ -z "${LAPTOP_HOME}" ]; then
  echo "LAPTOP_HOME variable is required"
  exit 1
fi

# Source env
# shellcheck disable=SC1091
source "$LAPTOP_HOME/lib/function/require.sh"

laptop_require "laptop_env_reload"
laptop_require "laptop_profile_select"
laptop_require "laptop_profile_dir"
laptop_require "laptop_profile_load"
laptop_require "laptop_source_all"

# Reload environment
laptop_env_reload

# Source global functions
laptop_source_all "$LAPTOP_LIB_DIR/function"

## Screen Dimensions

quote() {
  local quoted=${1//\'/\'\\\'\'}
  printf "'%s'" "$quoted"
}

# Select profile
laptop_profile_select

# Source profile functions
if [ -d "$(laptop_profile_dir)/function" ]; then
  laptop_source_all "$(laptop_profile_dir)/function"
fi

# Default handlers
laptop_handler__logo() {
  laptop_require "laptop_logo"

  laptop_logo
}

laptop_handler__setup_bootstrap() {
  laptop_require "laptop_setup_bootstrap"
  laptop_require "laptop_setup_xdg_desktop"
  laptop_require "laptop_setup_default_profile"

  laptop_setup_bootstrap
  laptop_setup_xdg_desktop
  laptop_setup_default_profile
}

laptop_handler__setup_shell() {
  laptop_require "laptop_setup_default_shell"

  laptop_setup_default_shell
}

# IMPORTANT: Load profile at the end
# Load profile (with overrides)# Load profile (with overrides)
laptop_profile_load
