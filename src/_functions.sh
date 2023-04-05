#!/usr/bin/env bash

if [ -z "${LAPTOP_ROOT_DIR}" ]; then
  SCRIPT_DIR="$(dirname "$0")"
  cd "$SCRIPT_DIR/.."
  export LAPTOP_ROOT_DIR=$(pwd)
  export LAPTOP_TEMPLATE_DIR="$LAPTOP_ROOT_DIR/resource"
  export LAPTOP_SOURCE_DIR="$LAPTOP_ROOT_DIR/src"

  export LAPTOP_PACKAGE_MANAGER=unknown
  if [ -x "$(command -v brew)" ]; then
    export LAPTOP_PACKAGE_MANAGER=brew
  fi
fi

## Screen Dimensions
# Find current screen size
#if [ -z "${COLUMNS}" ]; then
   #COLUMNS=$(stty size)
   #COLUMNS=${COLUMNS##* }
COLUMNS=80
#fi

# When using remote connections, such as a serial port, stty size returns 0
if [ "${COLUMNS}" = "0" ]; then
   COLUMNS=80
fi
COL=$((${COLUMNS} - 8))
SET_COL="\\033[${COL}G"
NORMAL="\\033[0;39m"
SUCCESS="\\033[1;32m"
BRACKET="\\033[1;34m"
COLOR_WARNING='\033[1;33m'

export HOMEBREW_NO_INSTALL_CLEANUP=true
export HOMEBREW_NO_ENV_HINTS=true

log_info_msg() {
  echo -n -e "${@}"
  return 0
}

log_success_msg() {
  echo -n -e "${@}"
  echo -e "${SET_COL}${BRACKET}[${SUCCESS}  OK  ${BRACKET}]${NORMAL}"
  return 0
}

log_failure_msg() {
  echo -n -e "${@}"
  echo -e "${SET_COL}${BRACKET}[${FAILURE} FAIL ${BRACKET}]${NORMAL}"
  return 0
}

log_pass_msg() {
  echo -n -e "${@}"
  echo -e "${SET_COL}${BRACKET}[${NORMAL} PASS ${BRACKET}]${NORMAL}"
  return 0
}

is_arm() {
  test arm64 = $(uname -m)
}

command_exists() {
  if [ -x "$(command -v $1)" ]; then
    return 0
  else
    return 1
  fi
}

ensure_rosetta2() {
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

ensure_xcode() {
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

ensure_brew() {
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

ensure_package() {
  local executable="$1"
  local package=${2:-$executable}
  local installation_message="- Ensure $executable"
  if [ $LAPTOP_PACKAGE_MANAGER = "brew" ];then
    if brew list $1 &>/dev/null; then
      log_success_msg "$installation_message"
    else
      brew install $package --quiet && \
      log_success_msg "$installation_message" || \
      log_failure_msg "$installation_message";
    fi
  fi
}

ensure_asdf_plugin() {
  local name="$1"
  local url="$2"
  local message="- Ensure asdf plugin $name"

  if ! asdf plugin-list | grep -Fq "$name"; then
    asdf plugin-add "$name" "$url" && \
    log_success_msg "$message" || \
    log_failure_msg "$message";
  else
    log_success_msg "$message"
  fi
}

ensure_asdf_language() {
  local language="$1"
  local version=$2 || "latest"

  local message="- Ensure asdf $language $version"
  if ! asdf list "$language" &>/dev/null; then
    asdf install "$language" "$version" && \
    asdf global "$language" "$version"  && \
    log_success_msg "$message" || \
    log_failure_msg "$message";
  else
    log_success_msg "$message"
  fi
}

ensure_git_config() {
  local name="$1"
  local value="$2"
  local message="- Ensure git config $name=$value"

  git config --global $name $value && \
    log_success_msg "$message" || \
    log_failure_msg "$message";
}

ensure_defaults_bool() {
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

set_zsh() {
  local shell_path;
  shell_path="$(command -v zsh)"

  # if ! grep "$shell_path" /etc/shells > /dev/null 2>&1 ; then
  #   sudo sh -c "echo $shell_path >> /etc/shells"
  # fi
  sudo chsh -s "$shell_path" "$USER"
}

ensure_zsh() {
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

ensure_directory() {
  local directory="$1"
  local message="- Ensure directory $directory"
  if [ ! -d $directory ]; then
    mkdir -p $directory && \
    log_success_msg $message || \
    log_failure_msg "$message"
  else
    log_success_msg $message
  fi
}

ensure_file_template() {
  local template="$1"
  local target="$2"
  local message="- Ensure file $target"

  mkdir -p $(dirname $target)
  cp "$LAPTOP_TEMPLATE_DIR/$template" "$target" && \
  log_success_msg $message || \
  log_failure_msg "$message"
}

_laptop_bootstrap_debian() {
  # sudo apt install -qq software-properties-common && \
  # sudo apt install -qq ansible
  return 0
}

_laptop_bootstrap_macos() {
  ensure_rosetta2
  ensure_xcode
  ensure_zsh
  ensure_brew
}

_laptop_bootstrap() {
  if ! command -v apt &> /dev/null; then
    _laptop_bootstrap_debian
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    _laptop_bootstrap_macos
  else
    return 1
  fi
}

_laptop_execute() {
  local shell=$1
  local script=$2
  env -i $shell --login $script
}


