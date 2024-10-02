#!/usr/bin/env bash

if [ -z "${LAPTOP_ROOT_DIR}" ]; then
  SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
  cd "$SCRIPT_DIR/.."
  export LAPTOP_ROOT_DIR=$(pwd)
  export LAPTOP_TEMPLATE_DIR="$LAPTOP_ROOT_DIR/resource"
  export LAPTOP_SOURCE_DIR="$LAPTOP_ROOT_DIR/src"

  export LAPTOP_PACKAGE_MANAGER=unknown
  if [ -x "$(command -v brew)" ]; then
    export LAPTOP_PACKAGE_MANAGER=brew
  elif [ -x "$(command -v apt-get)" ]; then
    export LAPTOP_PACKAGE_MANAGER=apt-get
  else
    return 0
  fi
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
SET_COL="\\033[${COL}G"
NORMAL="\\033[0;39m"
SUCCESS="\\033[1;32m"
BRACKET="\\033[1;34m"
COLOR_ERROR='\033[31m'
COLOR_WARNING='\033[1;33m'
COLOR_INFO='\033[32m'

BREW_CASK_PACKAGES=(
  "docker"
);

LAPTOP_SHELL="${LAPTOP_SHELL:-"zsh"}"

if [ -z "$LAPTOP_DEVCONTAINER" ]; then
  [[ "$(whoami)" = "vscode" ]] && LAPTOP_DEVCONTAINER="true"
fi

is_arm() {
  test arm64 = $(uname -m)
}

quote() {
  echo "'$1'"
}

eerror() {
  echo -e "${COLOR_ERROR}Error: ${NORMAL}${@}" >&2
}

ewarn() {
  echo -e "${COLOR_WARNING}Warning: ${NORMAL}${@}"
}

einfo() {
  echo -e "${COLOR_INFO}Info: ${NORMAL}${@}"
}

function_exists() {
  declare -f -F "$1" > /dev/null
  return $?
}

command_exists() {
  if [ -x "$(command -v "$1")" ]; then
    return 0
  else
    return 1
  fi
}

# Filter array keeping only available commands
#
# Example 1 :
#   filter_command_exists "brew" "npm" "yarn"
#   > "brew" "npm"
#
filter_command_exists() {
  local filtered_array=()
  for tool in "$@"; do
    case "$tool" in
      zi)
        if env "$SHELL" --login -i -c "command -v $tool" &>/dev/null; then
          filtered_array+=("$tool")
        fi
        ;;
      *)
        if command -v "$tool" &>/dev/null; then
          filtered_array+=("$tool")
        fi
        ;;
    esac
  done
  echo "${filtered_array[@]}"
}

# Confirm
#
# Example 1 :
#   confirm Delete file1? && echo rm file1
#
# Example 2 :
#   confirm Delete file2?
#   if [ $? -eq 0 ]
#
confirm() {
  echo -n "$@ "
  read -e answer
  for response in y Y yes YES Yes Sure sure SURE OK ok Ok
  do
    if [ "_$answer" == "_$response" ]
    then
      return 0
    fi
  done
  # Any answer other than the list above is considerred a "no" answer
  return 1
}

test_ssh_key() {
  local host="$1"
  ssh -T $host >/dev/null 2>&1
  if [ $? -ge 2 ]; then
    return -1
  else
    return 0
  fi
}

_laptop_shell() {
  local shell=$1
  local script=$2
  env "$shell" --login -i "$script"
}
