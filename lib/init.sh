#!/usr/bin/env bash

# shellcheck disable=SC2155
if [ -z "${LAPTOP_HOME}" ]; then
  echo "LAPTOP_HOME variable is required"
  exit 1
fi

# Source env
# shellcheck disable=SC1091
source "$LAPTOP_HOME/lib/function/env_reload.sh"
# shellcheck disable=SC1091
source "$LAPTOP_HOME/lib/function/xdg_dir.sh"

# Reload environment
laptop_env_reload

# Source scripts
# shellcheck disable=SC1091
source "$LAPTOP_LIB_DIR/function/source_all.sh"
# Source global functions
laptop_source_all "$LAPTOP_LIB_DIR/function"

# Default environment variables
export LAPTOP_PROFILE=${LAPTOP_PROFILE:-$(laptop_ini_get "$LAPTOP_USER_CONFIG_FILE" "profile")}

# Use ANSI colors default value
export LAPTOP_COLOR_MODE=${LAPTOP_COLOR_MODE:-"auto"}
export LAPTOP_COLOR=false

## Screen Dimensions
# Find current screen size
if [ -z "${COLUMNS}" ]; then
  COLUMNS=$(stty size 2>/dev/null | cut -d' ' -f2)
fi
# When using remote connections, such as a serial port, stty size returns 0
if [ -z "$COLUMNS" ]; then
  COLUMNS=80
fi
_LAPTOP_STEP_STATUS_COLUMN=$((COLUMNS - 8))
# shellcheck disable=SC2034
_LAPTOP_SET_COL="\\033[${_LAPTOP_STEP_STATUS_COLUMN}G"


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

# Source recipes
laptop_source_all "$LAPTOP_LIB_DIR/recipe"
# Source profile recipes
if [ -d "$(laptop_profile_dir)/recipe" ]; then
  laptop_source_all "$(laptop_profile_dir)/recipe"
fi

# Default handlers
laptop_handler__logo() {
  laptop_logo
}

laptop_handler__setup_bootstrap() {
  laptop_bootstrap
  laptop_setup_xdg_desktop
  laptop_setup_default_profile # FIXME: use this internal shell instead
  # laptop_shell_exec "zsh" "$(laptop_profile_dir default)/bootstrap-profile.zsh"
}

laptop_handler__setup_shell() {
  laptop_setup_default_shell
}

# IMPORTANT: Load profile at the end
# Load profile (with overrides)# Load profile (with overrides)
laptop_profile_load
