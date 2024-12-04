#!/usr/bin/env bash

if [ -z "${LAPTOP_HOME}" ]; then
  echo "LAPTOP_HOME variable is required"
  exit 1;
fi

export LAPTOP_HOME="$LAPTOP_HOME"
export LAPTOP_SOURCE_DIR="$LAPTOP_HOME/src"
export LAPTOP_PROFILE_DIR="$LAPTOP_HOME/profile"
export LAPTOP_PROFILE_DEFAULT="default"
# export LAPTOP_PROFILE=${LAPTOP_PROFILE:-default}

export LAPTOP_PACKAGE_MANAGER=unknown
if [ -x "$(command -v brew)" ]; then
  export LAPTOP_PACKAGE_MANAGER=brew
elif [ -x "$(command -v apt-get)" ]; then
  export LAPTOP_PACKAGE_MANAGER=apt-get
else
  return 0
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
COL=$(($COLUMNS - 8))
# shellcheck disable=SC2034
SET_COL="\\033[${COL}G"
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
COLOR_INFO='\033[32m'
# shellcheck disable=SC2034
BREW_CASK_PACKAGES=(
  "docker"
);

LAPTOP_SHELL="${LAPTOP_SHELL:-"zsh"}"

if [ -z "$LAPTOP_DEVCONTAINER" ]; then
  [[ "$(whoami)" = "vscode" ]] && LAPTOP_DEVCONTAINER="true"
fi

is_arm() {
  test arm64 = "$(uname -m)"
}

quote() {
  local quoted=${1//\'/\'\\\'\'};
  printf "'%s'" "$quoted"
}


# Source scripts
# shellcheck disable=SC1091
source "$LAPTOP_SOURCE_DIR/function/source_all.sh"
laptop::source_all "$LAPTOP_SOURCE_DIR/function"
laptop::source_all "$LAPTOP_SOURCE_DIR/recipes"
