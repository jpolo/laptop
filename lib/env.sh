#!/usr/bin/env bash

# shellcheck disable=SC2155

if [ -z "${LAPTOP_HOME}" ]; then
  echo "LAPTOP_HOME variable is required"
  exit 1
fi

export LAPTOP_APP_NAME="${LAPTOP_APP_NAME:-"laptop"}"

# Project directories
export LAPTOP_HOME="$LAPTOP_HOME"
export LAPTOP_LIB_DIR=${LAPTOP_LIB_DIR:-"$LAPTOP_HOME/lib"}
export LAPTOP_MAN_DIR=${LAPTOP_MAN_DIR:-"$LAPTOP_HOME/share/man/man1"}
export LAPTOP_TEST_DIR=${LAPTOP_TEST_DIR:-"$LAPTOP_HOME/test"}
export LAPTOP_PROFILE_DIR="$LAPTOP_HOME/profile"
export LAPTOP_PROFILE_DEFAULT="default"

# Set XDG directories
export LAPTOP_USER_CONFIG_DIR="$(laptop_xdg_dir config)/$LAPTOP_APP_NAME"
export LAPTOP_USER_DATA_DIR="$(laptop_xdg_dir data)/$LAPTOP_APP_NAME"
export LAPTOP_USER_CACHE_DIR="$(laptop_xdg_dir cache)/$LAPTOP_APP_NAME"
export LAPTOP_USER_STATE_DIR="$(laptop_xdg_dir state)/$LAPTOP_APP_NAME"

# Laptop configuration file
export LAPTOP_USER_CONFIG_FILE="$LAPTOP_USER_CONFIG_DIR/config.ini"

# Detect dev container
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

# Detect sudo
export LAPTOP_SUDO=true
if [ "$(whoami)" = "root" ]; then
  export LAPTOP_SUDO=false
fi

# Detect package manager
export LAPTOP_PACKAGE_MANAGER=${LAPTOP_PACKAGE_MANAGER:-"unknown"}
if [ "$LAPTOP_PACKAGE_MANAGER" = "unknown" ]; then
  if [ -x "$(command -v brew)" ]; then
    export LAPTOP_PACKAGE_MANAGER="brew"
  elif [ -x "$(command -v apt-get)" ]; then
    export LAPTOP_PACKAGE_MANAGER="apt-get"
  fi
fi

# Laptop shell used for running scripts
export LAPTOP_SHELL="${LAPTOP_SHELL:-"zsh"}"
