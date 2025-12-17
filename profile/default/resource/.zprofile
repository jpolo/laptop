#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
# ZSH startup script : login step
# .zshenv → >>>.zprofile<<< → .zshrc → .zlogin → .zlogout
#
# 🚨 Warning : this file was automatically generated, editing it is not recommended
#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

# https://blog.patshead.com/2011/04/improve-your-oh-my-zsh-startup-time-maybe.html
skip_global_compinit=1

# http://disq.us/p/f55b78
setopt noglobalrcs

if [ -f "${HOME}/.profile" ]; then
  source "${HOME}/.profile"
fi

# Try to load "$XDG_CONFIG_HOME/zsh/profile"
if [ -n "$XDG_CONFIG_HOME" ] && [ -f "$XDG_CONFIG_HOME/zsh/profile" ]; then
  source "$XDG_CONFIG_HOME/zsh/profile"
fi
# Try to load "$XDG_DATA_HOME/zsh/profile"
if [ -n "$XDG_DATA_HOME" ] && [ -f "$XDG_DATA_HOME/zsh/profile" ]; then
  source "$XDG_DATA_HOME/zsh/profile"
fi

# Make unique PATH
typeset -U PATH
