#!/usr/bin/env bash

# shellcheck disable=SC2155

# Change current directory to home
cd "$HOME" || exit 1

if [ -z "${LAPTOP_HOME}" ]; then
  echo "LAPTOP_HOME variable is required"
  exit 1
fi

LAPTOP_APP_NAME="laptop"

export LAPTOP_HOME="$LAPTOP_HOME"
export LAPTOP_LIB_DIR="$LAPTOP_HOME/lib"
export LAPTOP_PROFILE_DIR="$LAPTOP_HOME/profile"
export LAPTOP_PROFILE_DEFAULT="default"
# export LAPTOP_PROFILE=${LAPTOP_PROFILE:-default}

# Source scripts
# shellcheck disable=SC1091
source "$LAPTOP_LIB_DIR/function/source_all.sh"
# Source global functions
laptop_source_all "$LAPTOP_LIB_DIR/function"

# Set XDG directories
export LAPTOP_USER_CONFIG_DIR="$(laptop_xdg_dir config)/$LAPTOP_APP_NAME"
export LAPTOP_USER_DATA_DIR="$(laptop_xdg_dir data)/$LAPTOP_APP_NAME"
export LAPTOP_USER_CACHE_DIR="$(laptop_xdg_dir cache)/$LAPTOP_APP_NAME"
export LAPTOP_USER_STATE_DIR="$(laptop_xdg_dir state)/$LAPTOP_APP_NAME"

# Use default by default
export LAPTOP_SUDO=true
if [ "$(whoami)" = "root" ]; then
  export LAPTOP_SUDO=false
fi

if [ -z "$LAPTOP_DEVCONTAINER" ]; then
  if [[ "$(whoami)" = "vscode" ]]; then
    export LAPTOP_DEVCONTAINER="true"
  elif [ -f "/.dockerenv" ]; then
    export LAPTOP_DEVCONTAINER="true"
  elif [ -f "/proc/self/cgroup" ]; then
    export LAPTOP_DEVCONTAINER="true"
  else
    export LAPTOP_DEVCONTAINER="false"
  fi
fi

export LAPTOP_PACKAGE_MANAGER=unknown
if [ -x "$(command -v brew)" ]; then
  export LAPTOP_PACKAGE_MANAGER=brew
elif [ -x "$(command -v apt-get)" ]; then
  export LAPTOP_PACKAGE_MANAGER=apt-get
fi

## Screen Dimensions
# Find current screen size
#if [ -z "${COLUMNS}" ]; then
#COLUMNS=$(stty size)
#COLUMNS=${COLUMNS##* }
COLUMNS=100
#fi

# When using remote connections, such as a serial port, stty size returns 0
if [ "$COLUMNS" = "0" ]; then
  COLUMNS=80
fi
LAPTOP_STEP_STATUS_COLUMN=$((COLUMNS - 8))
# shellcheck disable=SC2034
SET_COL="\\033[${LAPTOP_STEP_STATUS_COLUMN}G"
# shellcheck disable=SC2034
NORMAL="\\033[0;39m"
# shellcheck disable=SC2034
SUCCESS="\\033[1;32m"
# shellcheck disable=SC2034
BRACKET="\\033[1;34m"
# shellcheck disable=SC2034
COLOR_ERROR='\033[31m'
# shellcheck disable=SC2034
COLOR_WARNING='\033[1;33m'
# shellcheck disable=SC2034
COLOR_INFO="\\033[32m"
# shellcheck disable=SC2034
COLOR_SUCCESS='\033[32m'
# shellcheck disable=SC2034
DIM="\\033[2m"

LAPTOP_SHELL="${LAPTOP_SHELL:-"zsh"}"

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
}

laptop_handler__setup_shell() {
  laptop_setup_default_shell
}

# IMPORTANT: Load profile at the end
# Load profile (with overrides)# Load profile (with overrides)
laptop_profile_load
