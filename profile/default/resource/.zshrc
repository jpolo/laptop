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
# This file uses zinit plugin manager (https://zdharma-continuum.github.io/)
#
# Example 1: Install and load OhMyZSH plugin named "ruby"
# `zinit snippet OMZP::ruby`

# Enable ZPROF for profiling when ZPROF environment variable is set
[[ -n "$ZPROF" ]] && zmodload zsh/zprof

#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
# Load .zprofile when it seems not to have loaded (Linux)
if [ -f "${HOME}/.zprofile" ]; then
  source "${HOME}/.zprofile"
fi

#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
##
# ZSH package manager : zi
##
ZINIT_HOME="$XDG_CACHE_HOME/zinit"
typeset -Ag ZINIT
typeset -gx ZINIT[HOME_DIR]="$ZINIT_HOME"
typeset -gx ZINIT[BIN_DIR]="$ZINIT_HOME/bin"
typeset -gx ZINIT[ZCOMPDUMP_PATH]="$XDG_CACHE_HOME/zsh/zcompdump"

if [[ ! -f "${ZINIT[BIN_DIR]}/zinit.zsh" ]]; then
  rm -rf "${ZINIT[BIN_DIR]}"
  # compaudit | xargs chown -R "$(whoami)" "$ZINIT[HOME_DIR]"
  # compaudit | xargs chmod -R go-w "$ZINIT[HOME_DIR]"
  command git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT[BIN_DIR]}"
  # zcompile "${ZINIT[BIN_DIR]}/bin/zi.zsh"
fi

if [[ -f "${ZINIT[BIN_DIR]}/zinit.zsh" ]]; then
  source "${ZINIT[BIN_DIR]}/zinit.zsh"
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit
else
  echo "zinit cannot be installed"
fi;

# Find the first command available
.zshrc-command-alternative() {
  for command_to_test in "$@"; do
    if type "$command_to_test" &>/dev/null; then
      printf "%s" "${command_to_test}"
      break
    fi
  done
}

# Load plugins
.zshrc-load-file() {
  if [ -f "$1" ]; then
    source "$1"
  fi
}

# Profile a command and print the results
zshrc_profile() {
  time ZPROF=1 zsh -i -c exit
}

#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
##
# Custom scripts
##

# Load .zshrc.local
[ -n "$XDG_CONFIG_HOME" ] && .zshrc-load-file "$XDG_CONFIG_HOME/zsh/init"
[ -n "$XDG_DATA_HOME" ] && .zshrc-load-file "$XDG_DATA_HOME/zsh/global.sh"
if [ -f "$XDG_DATA_HOME/zsh/personal.sh" ]; then
  echo "WARNING: $XDG_DATA_HOME/zsh/personal.sh detected"
  echo "  Its use is deprecated, and was replaced by $XDG_CONFIG_HOME/zsh/init"
  echo "  Run 'mv $XDG_DATA_HOME/zsh/personal.sh $XDG_CONFIG_HOME/zsh/init' to migrate"
fi
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

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
# Cleanup
##
unset -f .zshrc-command-alternative
unset -f .zshrc-load-file

# Print ZPROF results
[[ -n "$ZPROF" ]] && zprof
