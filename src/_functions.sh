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
APT_CORE_PACKAGES=(
  "build-essential"
  "procps"
  "curl"
  "file"
  "git"
  "software-properties-common"
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

test_ssh_key() {
  local host="$1"
  ssh -T $host >/dev/null 2>&1
  if [ $? -ge 2 ]; then
    return -1
  else
    return 0
  fi
}

ensure_shell() {
  local target_shell="$1";
  local current_shell="$(basename $SHELL)"

  _laptop_step_start "- Ensure shell '$target_shell'"
  if [ -z "$target_shell" ]; then
    _laptop_step_pass
  elif [ "$current_shell" = "$target_shell" ];then
    _laptop_step_ok
  else
    _laptop_step_exec sudo chsh -s "/bin/$target_shell"
  fi
}

ensure_zinit_updated() {
  _laptop_step_start "- Upgrade zinit"
  _laptop_step_eval "env zsh --login -i -c \"zinit update --all\""
}

ensure_package() {
  local executable="$1"
  local package=${2:-$executable}

  # Attempt to launch a function named ensure_package__$package" if exists
  local recipe_function="ensure_package__$package"
  if function_exists $recipe_function;then
    $recipe_function
    return 0
  else
    ensure_package_default "$executable" "$package"
  fi
}

ensure_package_default() {
  local executable="$1"
  local package=${2:-$executable}

  # Install using package manager
  if [ $LAPTOP_PACKAGE_MANAGER = "brew" ];then
    ensure_brew_package "$executable" "$package"
  elif [ $LAPTOP_PACKAGE_MANAGER = "apt-get" ];then
    ensure_apt_package "$executable" "$package"
  else
    _laptop_step_fail
  fi
}

ensure_brew_updated() {
  _laptop_step_start "- Upgrade brew"
  _laptop_step_eval "brew upgrade --quiet"
}

ensure_brew_package() {
  local executable="$1"
  local package=${2:-$executable}

  _laptop_step_start "- Ensure brew package '$executable'"

  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_NO_INSTALL_CLEANUP=1
  export HOMEBREW_NO_ENV_HINTS=1
  local brew_args=("--quiet")

  if [[ " ${BREW_CASK_PACKAGES[*]} " =~ " ${package} " ]]; then
    brew_args+=("--cask")
  fi

  if brew list $package &>/dev/null; then
    _laptop_step_ok
  else
    _laptop_step_eval "brew install $(quote ${brew_args[@]}) $(quote $package)"
  fi
}

ensure_brew_tap() {
  local tap="$1"
  _laptop_step_start "- Ensure brew tap '$tap'"
  _laptop_step_eval "brew tap $tap"
}

ensure_apt_key() {
  local repo_key="$1"
  _laptop_step_start "- Ensure apt key '$repo_url'"
  _laptop_step_eval "! wget -qO - "$repo_key" | sudo apt-key add -"
}

ensure_apt_repository() {
  local repo_url="$1"
  local repo_key="$2"

  ensure_apt_key "$repo_key"

  _laptop_step_start "- Ensure apt repository '$repo_url'"
  # Check if the repository is already added
  if grep -q "^deb .*$repo_url" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    _laptop_step_ok
  else
    _laptop_step_eval "echo 'deb $repo_url' | sudo tee -a /etc/apt/sources.list.d/custom.list >/dev/null && sudo apt-get update"
  fi
}

ensure_apt_updated() {
  _laptop_step_start "- Ensure APT updated"
  if [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ | wc -l)" = "0" ]; then
    _laptop_step_exec sudo apt-get update;
  else
    _laptop_step_ok
  fi
}

ensure_apt_package() {
  local executable="$1"
  local package=${2:-$executable}

  _laptop_step_start "- Ensure apt package '$executable'"
  if dpkg -s "$package" &>/dev/null; then
    _laptop_step_ok
  else
    _laptop_step_eval "sudo apt-get install $(quote $package) -yy"
  fi
}

ensure_npm_package() {
  local package="$1"

  _laptop_step_start "- Ensure NPM package '$package'"
  local npm_args=("--quiet --global")

  if [ ! -z "$(npm list --global --parseable "$package")" ]; then
    _laptop_step_ok
  else
    _laptop_step_eval "npm install ${npm_args[@]} $(quote $package)"
  fi
}

ensure_asdf_plugin() {
  local name="$1"
  local url="$2"
  _laptop_step_start "- Ensure asdf plugin '$name'"

  if ! asdf plugin-list | grep -Fq "$name"; then
    _laptop_step_exec asdf plugin-add "$name" "$url"
  else
    _laptop_step_ok
  fi
}

ensure_asdf_updated() {
  _laptop_step_start "- Upgrade asdf"
  _laptop_step_exec asdf plugin update --all
}

ensure_asdf_tool() {
  local language="$1"
  local version=$2 || "latest"

  _laptop_step_start "- Ensure asdf '$language' '$version'"
  if ! asdf list "$language" | grep -Fq "$version"; then
    _laptop_step_exec \
      asdf install "$language" "$version" && \
      asdf global "$language" "$version"
  else
    _laptop_step_exec \
      asdf global "$language" "$version"
  fi
}

ensure_git_config() {
  local name="$1"
  local value="$2"

  _laptop_step_start "- Ensure git config '$name'='${value:-"<custom>"}'"
  if [ -z "$(git config --global "$name")" ]; then
    if [ -z "${value}" ]; then
      echo "Git: Please enter value for '$name'"
      read value
    fi

    _laptop_step_exec git config --global "$name" "$value"
  else
    _laptop_step_ok
  fi
}

ensure_ssh_key() {
  local algorithm=${1:-"ed25519"}
  local ssh_key="$HOME/.ssh/id_$algorithm"
  local email=$(git config --global user.email)

  _laptop_step_start "- Ensure SSH key '$ssh_key'"
  if [ -z "$email" ];then
    _laptop_step_fail
    eerror "git config user.email is empty";
  elif ! [ -f "$ssh_key" ]; then
    _laptop_step_exec ssh-keygen -t $algorithm -C "$email" -N '' -o -f $ssh_key
  else
    _laptop_step_ok
  fi
}

ensure_defaults() {
  _laptop_step_start "- Ensure defaults ${@}"
  if command_exists "defaults"; then
    _laptop_step_exec defaults write ${@}
  else
    _laptop_step_pass
  fi
}

ensure_directory() {
  local directory="$1"
  _laptop_step_start "- Ensure directory '$directory'"
  if [ ! -d $directory ]; then
    _laptop_step_eval "mkdir -p $(quote $directory)"
  else
    _laptop_step_ok
  fi
}

ensure_file() {
  local file_path="$1"
  _laptop_step_start "- Ensure file '$file_path'"

  _laptop_step_eval "\
    mkdir -p $(quote $(dirname $file_path)) && \
    touch $(quote $file_path)
    "
}

ensure_file_template() {
  local template="$1"
  local target="$2"

  _laptop_step_start "- Ensure file '$target'"
  _laptop_step_eval "\
  mkdir -p $(quote $(dirname $target)) && \
  cp -f $(quote $LAPTOP_TEMPLATE_DIR/$template) $(quote $target) \
  "
}

ensure_vscode_extension() {
  local extension_name="$1"
  local list_extensions=$(code --list-extensions);
  _laptop_step_start "- Ensure VSCode '$extension_name'"

  if echo $list_extensions | grep -q $extension_name; then
    _laptop_step_ok
  else
    _laptop_step_exec code --install-extension "$extension_name" --force
  fi
}

ensure_vscode_setting() {
  local json_path="$1"
  local json_value="$2"
  local vscode_settings_file=""
  local jsonc_args="-v $(quote "$json_value")"
  if [ "$json_value" = "" ]; then
    jsonc_args=("--delete")
  fi

  # Vérifier si le système d'exploitation est macOS
  if [[ "$OSTYPE" == "darwin"* ]]; then
    vscode_settings_file="$HOME/Library/Application Support/Code/User/settings.json"
  else
    vscode_settings_file="$HOME/.config/Code/User/settings.json"
  fi

  # Vérifier si la requête est vide
  if [ -z "$json_path" ]; then
    eerror "La requête est vide."
    return 1
  fi

  _laptop_step_start "- Ensure VSCode Setting $json_path=$json_value"
  _laptop_step_eval "\
  cat $(quote $vscode_settings_file) | \
  jsonc modify -n -m -p $(quote $json_path) $jsonc_args -f $(quote $vscode_settings_file) \
  "
}

_laptop_ensure_rosetta2() {
  # Install Rosetta
  _laptop_step_start "- Ensure Rosetta 2"
  if is_arm && ! test -f /Library/Apple/usr/share/rosetta/rosetta; then
    _laptop_step_exec sudo softwareupdate --install-rosetta  --agree-to-license
  else
    _laptop_step_ok
  fi
}

_laptop_ensure_brew() {
  # Install Homebrew
  local brew_present=$(env -i zsh --login -c 'command -v brew');
  _laptop_step_start "- Ensure package manager 'brew'"

  if [ -z "$brew_present" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    # eval "$(/opt/homebrew/bin/brew shellenv)" && \;
    _laptop_step_ok
  else
    _laptop_step_ok
  fi
}

_laptop_ensure_brew_autodate() {
  local brew_autodate_present=$(env -i zsh --login -c 'brew autoupdate status &>/dev/null;echo $?');

  _laptop_step_start "- Ensure package manager 'brew autoupdate'"
  if [ "$brew_autodate_present" != "0" ]; then
    brew tap homebrew/autoupdate
  fi

  if ! brew autoupdate status | grep --quiet running; then
    brew autoupdate start &>/dev/null && \
      _laptop_step_ok || \
      _laptop_step_fail
  else
    _laptop_step_ok
  fi
}

_laptop_ensure_shell() {
  ensure_shell "$LAPTOP_SHELL"
}

_laptop_ensure_xcode() {
  # Install XCode
  _laptop_step_start "- Ensure Build tools"
  if ! [ -x "$(command -v gcc)" ]; then
    _laptop_step_exec xcode-select --install;
  else
    _laptop_step_ok
  fi
}

_laptop_ensure_apt_core() {
  _laptop_step_start "- Ensure APT core packages"
  _laptop_step_exec sudo apt-get install "${APT_CORE_PACKAGES[@]}" -yy;
}

_laptop_bootstrap_debian() {
  _laptop_ensure_shell
  ensure_apt_updated
  _laptop_ensure_apt_core
}

_laptop_bootstrap_macos() {
  _laptop_ensure_rosetta2
  _laptop_ensure_xcode
  _laptop_ensure_shell
  _laptop_ensure_brew
  ensure_brew_updated
  _laptop_ensure_brew_autodate
}

_laptop_bootstrap() {
  if command -v apt-get &> /dev/null; then
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
  env "$shell" --login -i "$script"
}

_laptop_step_start() {
  echo -n -e "${@}"
  return 0
}

_laptop_step_ok() {
  # echo -n -e "${@}"
  echo -e "${SET_COL}${BRACKET}[${SUCCESS}  OK  ${BRACKET}]${NORMAL}"
  return 0
}

_laptop_step_fail() {
  # echo -n -e "${@}"
  echo -e "${SET_COL}${BRACKET}[${FAILURE} FAIL ${BRACKET}]${NORMAL}"
  return 0
}

_laptop_step_pass() {
  #echo -n -e "${@}"
  echo -e "${SET_COL}${BRACKET}[${NORMAL} PASS ${BRACKET}]${NORMAL}"
  return 0
}

_laptop_step_complete() {
  local command=$1
  local exit_code=$2
  local output=$3

  if [ "$exit_code" = "0" ]; then
    _laptop_step_ok
  else
    _laptop_step_fail
    eerror "Command failed \
      \\n|  > $command \
      \\n|  $output"
  fi
}

_laptop_step_exec() {
  _laptop_step_eval "$*"
}

_laptop_step_eval() {
  local output;
  local command="$1"
  output=$(eval "$command" 2>&1)
  local exit_code=$?

 _laptop_step_complete "$command" "$exit_code" "$output"
}

_laptop_cleanup() {
  _laptop_step_start "- Upgrade zinit"
  _laptop_step_exec zinit update --all --no-pager --quiet --parallel

  _laptop_step_start "- Clean zinit"
  _laptop_step_exec zinit delete --clean --quiet --yes
}
