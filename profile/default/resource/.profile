#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
# Shell profile initialization script
#
# 🚨 Warning : this file was automatically generated, editing it is not recommended
#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

# Initialize XDG Base Directory specification variables
.profile-xdg-init() {
  local darwin_temp=""

  if [ -z "${XDG_BIN_HOME:-}" ]; then
    export XDG_BIN_HOME="$HOME/.local/bin"
  fi

  case "${OSTYPE:-}" in
    darwin*)
      : "${XDG_CONFIG_HOME:=$HOME/Library/Preferences}"
      : "${XDG_CACHE_HOME:=$HOME/Library/Caches}"
      : "${XDG_DATA_HOME:=$HOME/Library}"
      : "${XDG_STATE_HOME:=$HOME/Library/Application Support}"
      if command -v getconf >/dev/null 2>&1; then
        darwin_temp="$(getconf DARWIN_USER_TEMP_DIR 2>/dev/null || true)"
      fi
      : "${XDG_RUNTIME_DIR:=${darwin_temp:-}}"
      ;;
    *)
      : "${XDG_CONFIG_HOME:=$HOME/.config}"
      : "${XDG_CACHE_HOME:=$HOME/.cache}"
      : "${XDG_DATA_HOME:=$HOME/.local/share}"
      : "${XDG_STATE_HOME:=$HOME/.local/state}"
      : "${XDG_RUNTIME_DIR:=/run/user/${UID:-$(id -u 2>/dev/null)}}"
      ;;
  esac

  : "${XDG_DESKTOP_DIR:=$HOME/Desktop}"
  : "${XDG_DOCUMENTS_DIR:=$HOME/Documents}"
  : "${XDG_DOWNLOAD_DIR:=$HOME/Downloads}"
  : "${XDG_MUSIC_DIR:=$HOME/Music}"
  : "${XDG_PICTURES_DIR:=$HOME/Pictures}"
  : "${XDG_PUBLICSHARE_DIR:=$HOME/Public}"
  : "${XDG_TEMPLATES_DIR:=$HOME/Templates}"
  : "${XDG_VIDEOS_DIR:=$HOME/Videos}"

  export XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_STATE_HOME
  export XDG_DESKTOP_DIR XDG_DOCUMENTS_DIR XDG_DOWNLOAD_DIR XDG_MUSIC_DIR
  export XDG_PICTURES_DIR XDG_PUBLICSHARE_DIR XDG_TEMPLATES_DIR XDG_VIDEOS_DIR

  if [ -n "$XDG_RUNTIME_DIR" ] && [ -d "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR
  else
    unset XDG_RUNTIME_DIR
  fi

  mkdir -p "$XDG_BIN_HOME" "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"

  if [ -r "${XDG_CONFIG_HOME}/user-dirs.dirs" ]; then
    . "${XDG_CONFIG_HOME}/user-dirs.dirs"
    # TODO export variables
  fi
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
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
export CODEX_HOME="$XDG_CONFIG_HOME/codex"
export COPILOT_HOME="$XDG_CONFIG_HOME/copilot"
export CP_HOME_DIR="$XDG_DATA_HOME/cocoapods"
# export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker" 🟠 Does not work well on macOS
export ELM_HOME="$XDG_CONFIG_HOME/elm"
export MACHINE_STORAGE_PATH="$XDG_DATA_HOME/docker-machine"
export GHCUP_USE_XDG_DIRS=1
# export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
export GEMINI_CLI_HOME="$XDG_CONFIG_HOME/gemini"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export GRADLE_USER_HOME="$XDG_CACHE_HOME/gradle"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export JENV_ROOT="$XDG_DATA_HOME/jenv"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export K9SCONFIG="$XDG_CONFIG_HOME/k9s"
export KUBECONFIG="$XDG_CONFIG_HOME/kube/config"
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
# export PSQLRC="$XDG_CONFIG_HOME/pg/psqlrc"
export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"
# export PGPASSFILE="$XDG_CONFIG_HOME/pg/pgpass"
# export PGSERVICEFILE="$XDG_CONFIG_HOME/pg/pg_service.conf"
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export PYTHON_HISTORY="$XDG_STATE_HOME/python_history"
export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"
export PYTHONUSERBASE="$XDG_DATA_HOME/python"
export RBENV_ROOT="$XDG_DATA_HOME/rbenv"
export RUFF_CACHE_DIR="$XDG_CACHE_HOME/ruff"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export SOLARGRAPH_CACHE="$XDG_CACHE_HOME/solargraph"
export STARSHIP_CACHE="$XDG_CACHE_HOME/starship"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/config.toml"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export VOLTA_HOME="$XDG_DATA_HOME/volta"
# export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
# export VSCODIUM_PORTABLE="$XDG_DATA_HOME/vscode"

# Initialize brew (skip if already initialized to avoid the subprocess cost on every shell)
if [ -z "${HOMEBREW_PREFIX:-}" ]; then
  for prefix in "/opt/homebrew" "/usr/local" "$HOME/.linuxbrew" "/home/linuxbrew/.linuxbrew"; do
    if [ -f "$prefix/bin/brew" ]; then
      eval "$("$prefix/bin/brew" shellenv)"
      break
    fi
  done
fi

# Auto-detect Android SDK directory
if [ -z "${ANDROID_HOME:-}" ]; then
  if [ -d "$HOME/Library/Android/sdk" ]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
  elif [ -d "/usr/local/opt/android-sdk" ]; then
    export ANDROID_HOME="/usr/local/opt/android-sdk"
  fi
fi

# https://github.com/sorin-ionescu/prezto/blob/master/runcoms/zshenv
# Ensure that a non-login, non-interactive shell has a defined environment.
# if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
#   source "${ZDOTDIR:-$HOME}/.zprofile"
# fi

# Deterministic PATH Builder
.profile-add-candidate() {
  local candidate="$1"

  [ -n "$candidate" ] || return 0
  [ -d "$candidate" ] || return 0

  case "$candidate" in
    *":"*) return 0 ;;
  esac

  case ":${BUILDING_PATH}:" in
    *":${candidate}:"*) ;;
    *) BUILDING_PATH="${BUILDING_PATH:+$BUILDING_PATH:}$candidate" ;;
  esac
}

.profile-rebuild-path() {
  local BUILDING_PATH=""
  local old_path="$PATH"
  local old_ifs="${IFS-}"
  local dir

  # 1. Higher-priority developer tools
  .profile-add-candidate "$ASDF_DATA_DIR/shims"
  .profile-add-candidate "$XDG_BIN_HOME"

  # 2. Homebrew binaries
  if [ -n "${HOMEBREW_PREFIX:-}" ]; then
    .profile-add-candidate "$HOMEBREW_PREFIX/bin"
    .profile-add-candidate "$HOMEBREW_PREFIX/sbin"
  fi

  # 3. Android SDK tools
  if [ -n "${ANDROID_HOME:-}" ]; then
    .profile-add-candidate "$ANDROID_HOME/platform-tools"
    .profile-add-candidate "$ANDROID_HOME/cmdline-tools/latest/bin"
  fi

  # 4. Language package managers
  if [ -n "${CARGO_HOME:-}" ]; then
    .profile-add-candidate "$CARGO_HOME/bin"
  fi
  if [ -n "${GEM_HOME:-}" ]; then
    .profile-add-candidate "$GEM_HOME/bin"
  fi

  # 5. Distribution-specific package tools
  .profile-add-candidate "/snap/bin"

  # 6. Existing PATH entries (excluding system locations handled explicitly)
  IFS=':'
  set -f
  for dir in $old_path; do
    case "$dir" in
      ""|"."|/usr/local/sbin|/usr/local/bin|/usr/sbin|/usr/bin|/sbin|/bin)
        ;;
      *)
        .profile-add-candidate "$dir"
        ;;
    esac
  done
  set +f
  if [ -n "$old_ifs" ]; then
    IFS="$old_ifs"
  else
    unset IFS
  fi

  # 7. Standard System Directories
  .profile-add-candidate "/usr/local/sbin"
  .profile-add-candidate "/usr/local/bin"
  .profile-add-candidate "/usr/sbin"
  .profile-add-candidate "/usr/bin"
  .profile-add-candidate "/sbin"
  .profile-add-candidate "/bin"

  PATH="$BUILDING_PATH"
  export PATH
}

.profile-rebuild-path

# Clean functions
unset -f \
  .profile-xdg-init \
  .profile-add-candidate \
  .profile-rebuild-path
