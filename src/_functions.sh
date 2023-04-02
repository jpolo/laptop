#!/usr/bin/env bash

## Screen Dimensions
# Find current screen size
if [ -z "${COLUMNS}" ]; then
   #COLUMNS=$(stty size)
   #COLUMNS=${COLUMNS##* }
   COLUMNS=80
fi

# When using remote connections, such as a serial port, stty size returns 0
if [ "${COLUMNS}" = "0" ]; then
   COLUMNS=80
fi
COL=$((${COLUMNS} - 8))
SET_COL="\\033[${COL}G"
NORMAL="\\033[0;39m"
SUCCESS="\\033[1;32m"
BRACKET="\\033[1;34m"

PACKAGE_MANAGER=unknown

log_info_msg()
{
    echo -n -e "${@}"
    return 0
}

log_success_msg()
{
    echo -n -e "${@}"
    echo -e "${SET_COL}${BRACKET}[${SUCCESS}  OK  ${BRACKET}]${NORMAL}"
    return 0
}

log_failure_msg()
{
    echo -n -e "${@}"
    echo -e "${SET_COL}${BRACKET}[${FAILURE} FAIL ${BRACKET}]${NORMAL}"
    return 0
}

log_pass_msg()
{
    echo -n -e "${@}"
    echo -e "${SET_COL}${BRACKET}[${NORMAL} PASS ${BRACKET}]${NORMAL}"
    return 0
}

is_arm()
{
  test arm64 = $(uname -m)
}

command_exists()
{
  if [ -x "$(command -v $1)" ]; then
    return 0
  else
    return 1
  fi
}

ensure_rosetta2()
{
  # Install Rosetta
  local rosetta_installation_message="- Ensure Rosetta 2"
  if is_arm && ! test -f /Library/Apple/usr/share/rosetta/rosetta; then
    sudo softwareupdate --install-rosetta  --agree-to-license && \
    log_success_msg "$rosetta_installation_message" || \
    log_failure_msg "$rosetta_installation_message";
  else
    log_success_msg "$rosetta_installation_message"
  fi
}

ensure_xcode()
{
  # Install XCode
  local xcode_installation_message="- Ensure Build tools"
  if ! [ -x "$(command -v gcc)" ]; then
    xcode-select --install && \
    log_success_msg "$xcode_installation_message" || \
    log_failure_msg "$xcode_installation_message";
  else
    log_success_msg "$xcode_installation_message"
  fi
}

ensure_brew()
{
  # Install Homebrew
  local brew_installation_message="- Ensure Brew"
  if ! [ -x "$(command -v brew)" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)" && \
    log_success_msg "$brew_installation_message" || \
    log_failure_msg "$brew_installation_message";
  else
    log_success_msg "$brew_installation_message"
  fi
}

ensure_package()
{
  local executable="$1"
  local package=${2:-$executable}
  local installation_message="- Ensure $executable"

  if [ $PACKAGE_MANAGER == "brew" ];then
    if brew list $1 &>/dev/null; then
      log_success_msg "$installation_message"
    else
      brew install $package --quiet && \
      log_success_msg "$installation_message" || \
      log_failure_msg "$installation_message";
    fi
  fi
}

ensure_defaults_bool()
{
  local domain="$1"
  local key="$2"
  local value="$3"
  local installation_message="- Ensure defaults $domain $key=$value"
  if command_exists "defaults";then
    defaults write -g $domain $key -bool $value && \
    log_success_msg $installation_message || \
    log_failure_msg "$installation_message";
  else
    log_pass_msg $installation_message
  fi
}

set_zsh()
{
  local shell_path;
  shell_path="$(command -v zsh)"

  # if ! grep "$shell_path" /etc/shells > /dev/null 2>&1 ; then
  #   sudo sh -c "echo $shell_path >> /etc/shells"
  # fi
  sudo chsh -s "$shell_path" "$USER"
}

ensure_zsh()
{
  local message="- Ensure ZSH as shell"

  case "$SHELL" in
  */zsh)
    log_success_msg $message
    ;;
  *)
    set_zsh && \
    log_success_msg $message || \
    log_failure_msg "$message"
    ;;
  esac
}

bootstrap_debian()
{
  # sudo apt install -qq software-properties-common && \
  # sudo apt install -qq ansible
  return 0
}

bootstrap_macos()
{
  PACKAGE_MANAGER=brew
  ensure_rosetta2
  ensure_xcode
  ensure_zsh
  ensure_brew
}

bootstrap()
{
  if ! command -v apt &> /dev/null; then
    bootstrap_debian
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    bootstrap_macos
  else
    return 1
  fi
}


