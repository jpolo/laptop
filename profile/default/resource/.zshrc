#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
# ZSH startup script : interactive step
# .zshenv → .zprofile → >>>.zshrc<<< → .zlogin → .zlogout
#
# 🚨 Warning : this file was automatically generated, editing it is not recommended
#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

# ❓ HELP
#
# 1️/ CUSTOMIZE CONFIGURATION
#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
#
# There are multiple ways to override / extends this configuration :
#
# 👉 [Recommended] Shared (could be synchronizable to iCloud, Drive, etc) :
#
# > code "$XDG_CONFIG_HOME/zsh/init"
#
# 👉 Local only :
#
# > code "~/.zshrc.local"
#
# 2/ HOWTO ADD ZSH PLUGIN ?
# ⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
#
# Plugins are declared in $ZIM_CONFIG_FILE (zimfw's zimrc).
#
# Example: Install and load an Oh-My-Zsh plugin named "ruby" with:
# `zmodule ohmyzsh/ohmyzsh --root plugins/ruby`

#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
# Enable ZPROF for profiling when ZPROF environment variable is set
[[ -n "$ZPROF" ]] && zmodload zsh/zprof

#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
##
# Functions
##

# Source a file if it exists
.zshrc-load-file() {
  [ -f "$1" ] && source "$1"
}

# Source a file or a directory appending .d to the base file name if it exists
.zshrc-load-file-wildcard() {
  local base_file="$1"
  local directory="$base_file.d"
  if [ -d "$directory" ]; then
    for file in "$directory"/*; do
      source "$file"
    done
  fi
  .zshrc-load-file "$base_file"
}

# Find the first command available
.zshrc-command-alternative() {
  for command_to_test in "$@"; do
    if type "$command_to_test" &>/dev/null; then
      printf "%s" "${command_to_test}"
      break
    fi
  done
}

# Profile a command and print the results
zshrc_profile() {
  time ZPROF=1 zsh -i -c exit
}

#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
# Load .zprofile when it seems not to have loaded (Linux)
.zshrc-load-file "$HOME/.zprofile"

#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
##
# ZSH package manager : zimfw
##
: "${ZIM_HOME:=${XDG_CONFIG_HOME:-$HOME/.config}/zim}"
: "${ZIM_CONFIG_FILE:=$ZIM_HOME/zimrc}"
export ZIM_HOME ZIM_CONFIG_FILE

# Load Homebrew completions before zimfw initializes completion.
if type brew &>/dev/null; then
  : "${HOMEBREW_PREFIX:=$(brew --prefix)}"
  FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:$FPATH"
fi

if [[ ! -s "$ZIM_HOME/zimfw.zsh" ]]; then
  command mkdir -p "$ZIM_HOME"
  if command -v curl &>/dev/null; then
    command curl -fsSL -o "$ZIM_HOME/zimfw.zsh" https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh || command rm -f "$ZIM_HOME/zimfw.zsh"
  elif command -v wget &>/dev/null; then
    command wget -nv -O "$ZIM_HOME/zimfw.zsh" https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh || command rm -f "$ZIM_HOME/zimfw.zsh"
  else
    echo "zimfw cannot be installed: curl or wget is required" >&2
  fi
fi

if [[ -s "$ZIM_HOME/zimfw.zsh" ]]; then
  if [[ ! -s "$ZIM_HOME/init.zsh" || "$ZIM_CONFIG_FILE" -nt "$ZIM_HOME/init.zsh" ]]; then
    source "$ZIM_HOME/zimfw.zsh" init
  fi
  if [[ -f "$ZIM_HOME/init.zsh" ]]; then
    source "$ZIM_HOME/init.zsh"
  else
    echo "zimfw initialization failed" >&2
  fi
else
  echo "zimfw cannot be installed" >&2
fi

#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
##
# History
##
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ -z "$HISTSIZE" ] && HISTSIZE=290000
[ -z "$SAVEHIST" ] && SAVEHIST=$HISTSIZE

# Ensure history file exists
if [ ! -d "$(dirname $HISTFILE)" ]; then
  mkdir -p "$(dirname $HISTFILE)"
  touch $HISTFILE
fi

##
# Editor and Pager
##
if [ -z "$PAGER" ]; then
  export PAGER=$(.zshrc-command-alternative most less more)
fi

if [ -z "$EDITOR" ]; then
  if [[ -n $SSH_CONNECTION ]]; then # SSH mode
    EDITOR=$(.zshrc-command-alternative nano vim vi)
  else
    EDITOR=$(.zshrc-command-alternative cursor code subl nano vim vi)
  fi
  # Add --wait flag for code, cursor for diff editing etc
  if [[ "$EDITOR" == "code" || "$EDITOR" == "cursor" ]]; then
    EDITOR="$EDITOR --wait"
  fi
  export EDITOR
fi

if [ -z "$VISUAL" ] && [ ! -z "$EDITOR" ]; then
  export VISUAL="$EDITOR"
fi

#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
##
# Custom scripts
##

# Load .zshrc.local
[ -n "$XDG_CONFIG_HOME" ] && .zshrc-load-file-wildcard "$XDG_CONFIG_HOME/zsh/init"
[ -n "$XDG_DATA_HOME" ] && .zshrc-load-file-wildcard "$XDG_DATA_HOME/zsh/init"
if [ -f "$XDG_DATA_HOME/zsh/personal.sh" ]; then
  echo "WARNING: $XDG_DATA_HOME/zsh/personal.sh detected"
  echo "  Its use is deprecated, and was replaced by $XDG_CONFIG_HOME/zsh/init"
  echo "  Run 'mv $XDG_DATA_HOME/zsh/personal.sh $XDG_CONFIG_HOME/zsh/init' to migrate"
fi
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
##
# Cleanup
##
unset -f .zshrc-command-alternative
unset -f .zshrc-load-file
unset -f .zshrc-load-file-wildcard

# Print ZPROF results
[[ -n "$ZPROF" ]] && zprof
