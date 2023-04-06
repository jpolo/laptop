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
COLOR_ERROR='\033[31m'
COLOR_WARNING='\033[1;33m'
COLOR_INFO='\033[32m'

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

log_exec() {
  local command=$@
  local output;
  { output=$( { { "$@" ; } 1>&3 ; } 2>&1); } 3>&1
  local exit_code=$?

  if [ "$exit_code" = "0" ]; then
    log_success_msg
  else
    log_failure_msg $exit_code
    eerror Command failed \
      "\\n|  > $@" \
      "\\n|  $output"
  fi
}

is_arm() {
  test arm64 = $(uname -m)
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

command_exists() {
  if [ -x "$(command -v $1)" ]; then
    return 0
  else
    return 1
  fi
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

ensure_package() {
  local executable="$1"
  local package=${2:-$executable}
  local installation_message="- Ensure $executable"

  log_info_msg "$installation_message"
  if [ $LAPTOP_PACKAGE_MANAGER = "brew" ];then
    if brew list $1 &>/dev/null; then
      log_success_msg
    else
      log_exec brew install $package --quiet
    fi
  fi
}

ensure_asdf_plugin() {
  local name="$1"
  local url="$2"
  log_info_msg "- Ensure asdf plugin $name"

  if ! asdf plugin-list | grep -Fq "$name"; then
    log_exec asdf plugin-add "$name" "$url"
  else
    log_success_msg
  fi
}

ensure_asdf_language() {
  local language="$1"
  local version=$2 || "latest"

  log_info_msg "- Ensure asdf $language $version"
  if ! asdf list "$language" &>/dev/null; then
    log_exec \
      asdf install "$language" "$version" && \
      asdf global "$language" "$version"
  else
    log_success_msg
  fi
}

ensure_git_config() {
  local name="$1"
  local value="$2"

  log_info_msg "- Ensure git config $name=$value"
  if [ -z "$(git config --global $name)" ]; then
    if [ -z "${value}" ]; then
      echo "Git: Please enter value for '$name'"
      read value
    fi

    log_exec git config --global $name $value
  else
    log_success_msg
  fi
}

ensure_ssh_key() {
  local ssh_key=~/.ssh/id_ed25519
  local email=$(git config --global user.email)

  log_info_msg "- Ensure SSH key $ssh_key"
  if [ -z "$email" ];then
    log_failure_msg
    eerror "git config user.email is empty";
  elif ! [ -f "$ssh_key" ]; then
    log_exec ssh-keygen -t ed25519 -C "$email" -N '' -o -f $ssh_key
  else
    log_success_msg
  fi
}

ensure_defaults_bool() {
  local domain="$1"
  local key="$2"
  local value="$3"
  log_info_msg "- Ensure defaults $domain $key=$value"
  if command_exists "defaults"; then
    log_exec defaults write -g $domain $key -bool $value;
  else
    log_pass_msg
  fi
}

ensure_directory() {
  local directory="$1"
  log_info_msg "- Ensure directory $directory"
  if [ ! -d $directory ]; then
    log_exec mkdir -p $directory
  else
    log_success_msg
  fi
}

ensure_file() {
  local file_path="$1"
  log_info_msg "- Ensure file $file_path"

  log_exec \
    mkdir -p $(dirname $file_path) && \
    touch "$file_path"
}

ensure_file_template() {
  local template="$1"
  local target="$2"
  local message="- Ensure file $target"

  log_exec \
    mkdir -p $(dirname $target)
    cp "$LAPTOP_TEMPLATE_DIR/$template" "$target"
}

_laptop_ensure_rosetta2() {
  # Install Rosetta
  log_info_msg "- Ensure Rosetta 2"
  if is_arm && ! test -f /Library/Apple/usr/share/rosetta/rosetta; then
    log_exec sudo softwareupdate --install-rosetta  --agree-to-license
  else
    log_success_msg
  fi
}

_laptop_ensure_brew() {
  # Install Homebrew
  local brew_present=$(env -i zsh --login -c 'command -v brew');
  log_info_msg "- Ensure Brew"

  if [ -z "$brew_present" ]; then
    log_exec /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # eval "$(/opt/homebrew/bin/brew shellenv)" && \;
  else
    log_success_msg
  fi
}

_laptop_ensure_zsh() {
  log_info_msg "- Ensure ZSH as shell"

  case "$SHELL" in
  */zsh)
    log_success_msg
    ;;
  *)
    local shell_path="$(command -v zsh)"
    log_exec sudo chsh -s "$shell_path" "$USER"
    ;;
  esac
}

_laptop_ensure_xcode() {
  # Install XCode
  log_info_msg "- Ensure Build tools"
  if ! [ -x "$(command -v gcc)" ]; then
    log_exec xcode-select --install;
  else
    log_success_msg
  fi
}

_laptop_bootstrap_debian() {
  # sudo apt install -qq software-properties-common && \
  # sudo apt install -qq ansible
  return 0
}

_laptop_bootstrap_macos() {
  _laptop_ensure_rosetta2
  _laptop_ensure_xcode
  _laptop_ensure_zsh
  _laptop_ensure_brew
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

_laptop_shell() {
  local shell=$1
  local script=$2
  env -i $shell --login $script
}




