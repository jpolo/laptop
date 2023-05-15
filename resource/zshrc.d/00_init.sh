#zinit light rupa/z

# Theme
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

zinit ice nocompile:! pick:c.zsh atpull:%atclone atclone:'dircolors -b LS_COLORS > c.zsh'
zinit light trapd00r/LS_COLORS

# Fish like suggestions
zinit ice wait"0a" lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit ice wait:0a lucid atload'bindkey "$terminfo[kcuu1]" history-substring-search-up; bindkey "$terminfo[kcud1]" history-substring-search-down'
zinit light zsh-users/zsh-history-substring-search

##
# Completions
##
zinit ice wait"0b" lucid blockf
# Brew completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

# Zsh completions
zinit light zsh-users/zsh-completions

#OMZ::plugins/nvm/nvm.plugin.zsh \
zinit wait lucid for \
  OMZ::lib/correction.zsh \
  OMZ::lib/completion.zsh \
  OMZ::lib/grep.zsh \
  OMZ::lib/history.zsh \
  OMZ::lib/spectrum.zsh \
  OMZ::plugins/dotenv/dotenv.plugin.zsh \
  OMZ::plugins/asdf/asdf.plugin.zsh \
  hlissner/zsh-autopair

zinit ice silent wait:0c atload"ZINIT[COMPINIT_OPTS]=-C; zpcompinit"
zinit light zdharma-continuum/fast-syntax-highlighting

# NVM
# export NVM_LAZY_LOAD=true
# zinit light lukechilds/zsh-nvm

##
# History
##
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=290000
SAVEHIST=$HISTSIZE

##
# Editor
##
if [ -z "$EDITOR" ]; then
  if [[ -n $SSH_CONNECTION ]]; then # SSH mode
    export EDITOR='nano'
  elif type code &>/dev/null; then
    export EDITOR='code --wait'
  else # Local terminal mode
    # nothing
  fi
fi
if [ -z "$VISUAL" ] && [ ! -z "$EDITOR" ]; then
  export VISUAL="$EDITOR"
fi
