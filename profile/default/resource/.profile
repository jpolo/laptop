#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
# Shell profile initialization script
#
# 🚨 Warning : this file was automatically generated, editing it is not recommended
#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

.profile-path-prepend() {
  local new_path="$1"
  if [ -d "$new_path" ] && [[ ":$PATH:" != *":$new_path:"* ]]; then
    PATH="$new_path${PATH:+":$PATH"}"
  fi
}

.profile-path-append() {
  local new_path="$1"
  if [ -d "$new_path" ] && [[ ":$PATH:" != *":$new_path:"* ]]; then
    PATH="${PATH:+"$PATH:"}$new_path"
  fi
}

.profile-xdg-init() {
  # Make sure XDG dirs are set

  # Init default platform directories
  # https://github.com/adrg/xdg/blob/master/README.md#xdg-base-directory
  local XDG_CONFIG_HOME_DEFAULT XDG_CACHE_HOME_DEFAULT XDG_DATA_HOME_DEFAULT XDG_STATE_HOME_DEFAULT
  if [[ "$OSTYPE" == "darwin"* ]]; then
    XDG_BIN_HOME_DEFAULT="$HOME/.local/bin"
    XDG_CONFIG_HOME_DEFAULT="$HOME/Library/Preferences"
    XDG_CACHE_HOME_DEFAULT="$HOME/Library/Caches"
    XDG_DATA_HOME_DEFAULT="$HOME/Library"
    XDG_STATE_HOME_DEFAULT="$HOME/Library/Application Support"
    XDG_RUNTIME_DIR_DEFAULT=$(getconf DARWIN_USER_TEMP_DIR)
  else
    XDG_BIN_HOME_DEFAULT="$HOME/.local/bin"
    XDG_CONFIG_HOME_DEFAULT="$HOME/.config"
    XDG_CACHE_HOME_DEFAULT="$HOME/.cache"
    XDG_DATA_HOME_DEFAULT="$HOME/.local/share"
    XDG_STATE_HOME_DEFAULT="$HOME/.local/state"
    XDG_RUNTIME_DIR_DEFAULT="/run/user/$(id -u)"
  fi
  # export variables
  [[ -n "$XDG_BIN_HOME" ]] || export XDG_BIN_HOME=$XDG_BIN_HOME_DEFAULT
  [[ -n "$XDG_CONFIG_HOME" ]] || export XDG_CONFIG_HOME=$XDG_CONFIG_HOME_DEFAULT
  [[ -n "$XDG_CACHE_HOME"  ]] || export XDG_CACHE_HOME=$XDG_CACHE_HOME_DEFAULT
  [[ -n "$XDG_DATA_HOME"   ]] || export XDG_DATA_HOME=$XDG_DATA_HOME_DEFAULT
  [[ -n "$XDG_STATE_HOME"  ]] || export XDG_STATE_HOME=$XDG_STATE_HOME_DEFAULT

  # XDG directories
  [[ -n "$XDG_DESKTOP_DIR"     ]] || export XDG_DESKTOP_DIR="$HOME/Desktop"
  [[ -n "$XDG_DOCUMENTS_DIR"   ]] || export XDG_DOCUMENTS_DIR="$HOME/Documents"
  [[ -n "$XDG_DOWNLOAD_DIR"    ]] || export XDG_DOWNLOAD_DIR="$HOME/Downloads"
  [[ -n "$XDG_MUSIC_DIR"       ]] || export XDG_MUSIC_DIR="$HOME/Music"
  [[ -n "$XDG_PICTURES_DIR"    ]] || export XDG_PICTURES_DIR="$HOME/Pictures"
  [[ -n "$XDG_PUBLICSHARE_DIR" ]] || export XDG_PUBLICSHARE_DIR="$HOME/Public"
  [[ -n "$XDG_TEMPLATES_DIR"   ]] || export XDG_TEMPLATES_DIR="$HOME/Templates"
  [[ -n "$XDG_VIDEOS_DIR"      ]] || export XDG_VIDEOS_DIR="$HOME/Videos"
  [[ -n "$XDG_RUNTIME_DIR"    ]] || export XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR_DEFAULT

  # Source file
  [[ -r "${XDG_CONFIG_HOME}/user-dirs.dirs" ]] && {
    . ${XDG_CONFIG_HOME}/user-dirs.dirs
    # TODO export variables
  }
}

.profile-xdg-init

# jenv, rbenv, etc
export ANSIBLE_HOME="$XDG_CONFIG_HOME/ansible"
export ANSIBLE_GALAXY_CACHE_DIR="${XDG_CACHE_HOME}/ansible/galaxy_cache"
# export ASDF_DIR="$XDG_DATA_HOME/asdf"
export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/asdfrc"
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
export AZURE_CONFIG_DIR="$XDG_DATA_HOME/azure"
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"
export CABAL_DIR="$XDG_CACHE_HOME/cabal"
export CABAL_CONFIG="$XDG_CONFIG_HOME/cabal/config"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export CP_HOME_DIR="$XDG_DATA_HOME/cocoapods"
#export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker" 🟠 Does not work well on macOS
export ELM_HOME="$XDG_CONFIG_HOME/elm"
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME/docker-machine"
export GHCUP_USE_XDG_DIRS=1
# export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export GRADLE_USER_HOME="$XDG_CACHE_HOME/gradle"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export JENV_ROOT="$XDG_DATA_HOME/jenv"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export K9SCONFIG="$XDG_CONFIG_HOME/k9s"
export KUBECONFIG="$XDG_CONFIG_HOME/kube"
export KUBECACHEDIR="$XDG_CACHE_HOME/kube"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export MINIKUBE_HOME="$XDG_DATA_HOME/minikube"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node/repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/config"
# export NPM_CONFIG_PREFIX="$XDG_DATA_HOME/npm"
# export NPM_CONFIG_INIT_MODULE="$XDG_DATA_HOME"/npm/config/npm-init.js
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export npm_package_config_node_gyp_devdir="$XDG_CACHE_HOME/node-gyp"
# export rvm_path="$XDG_DATA_HOME/rvm"
export NVM_DIR="$XDG_DATA_HOME/nvm"
export OLLAMA_MODELS="$XDG_DATA_HOME/ollama/models"
export PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"
export POWERLEVEL9K_CONFIG_FILE="$XDG_CONFIG_HOME/zsh/p10k.zsh"
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export RBENV_ROOT="$XDG_DATA_HOME/rbenv"
export SOLARGRAPH_CACHE="$XDG_CACHE_HOME/solargraph"
export STARSHIP_CACHE="$XDG_CACHE_HOME/starship"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/config.toml"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export VOLTA_HOME="$XDG_DATA_HOME/volta"
# export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
# export VSCODIUM_PORTABLE="$XDG_DATA_HOME/vscode"


# Initialize brew
for prefix in "/opt/homebrew" "/usr/local" "$HOME/.linuxbrew" "/home/linuxbrew/.linuxbrew"
do
  if [ -f "$prefix/bin/brew" ] ; then
    eval "$("$prefix/bin/brew" shellenv)"
    break
  fi
done

if [ -z "$ANDROID_HOME" ]; then
  if [ -d "$HOME/Library/Android/sdk" ]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
  elif [ -d "/usr/local/opt/android-sdk" ]; then
    export ANDROID_HOME="/usr/local/opt/android-sdk"
  fi
  if [ ! -z "$ANDROID_HOME" ]; then
    .profile-path-append "$ANDROID_HOME/platform-tools"
    .profile-path-append "$ANDROID_HOME/cmdline-tools/latest/bin"
  fi
fi

# https://github.com/sorin-ionescu/prezto/blob/master/runcoms/zshenv
# Ensure that a non-login, non-interactive shell has a defined environment.
# if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
#   source "${ZDOTDIR:-$HOME}/.zprofile"
# fi

# set PATH so it includes user's private bin if it exists
.profile-path-prepend "/usr/sbin"
.profile-path-prepend "/usr/local/bin"
.profile-path-prepend "/snap/bin"
.profile-path-prepend "$HOME/bin"
.profile-path-prepend "$HOME/.bin"
.profile-path-prepend "$HOME/.local/bin"
if [ ! -z "$CARGO_HOME" ]; then
  .profile-path-append "$CARGO_HOME/bin"
fi
if [ ! -z "$GEM_HOME" ]; then
  .profile-path-append "$GEM_HOME/bin"
fi
.profile-path-append "$HOME/Application"
.profile-path-append "$HOME/Applications"
.profile-path-prepend "$ASDF_DATA_DIR/shims"
.profile-path-append "$HOME/.yarn/bin"
export PATH


# Clean functions
unset -f .profile-path-append .profile-path-prepend .profile-xdg-init
