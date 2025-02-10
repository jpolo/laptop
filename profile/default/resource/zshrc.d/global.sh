#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
# ZSH startup script : specific config
#
# 🔒🚨 Warning : this file was automatically generated, editing it is not recommended
#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

##
# Theme
##
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
POWERLEVEL9K_CONFIG_FILE="${XDG_CONFIG_HOME}/zsh/p10k.zsh"
if [[ -f "$POWERLEVEL9K_CONFIG_FILE" ]]; then
  source "$POWERLEVEL9K_CONFIG_FILE"
fi

if command -v zinit &>/dev/null; then
  # When zinit is available
  zinit ice depth=1
  zinit light romkatv/powerlevel10k

  # zinit ice nocompile:! pick:c.zsh atpull:%atclone atclone:'dircolors -b LS_COLORS > c.zsh'
  # zinit light trapd00r/LS_COLORS

  # Fish like suggestions
  zinit ice wait"0a" lucid atload"_zsh_autosuggest_start"
  zinit light zsh-users/zsh-autosuggestions

  zinit ice wait:0a lucid atload'bindkey "$terminfo[kcuu1]" history-substring-search-up; bindkey "$terminfo[kcud1]" history-substring-search-down'
  zinit light zsh-users/zsh-history-substring-search

  ##
  # Completions
  ##

  # Docker completion
  zinit as"completion" wait lucid for \
    OMZ::plugins/docker/completions/_docker \
    OMZ::plugins/docker-compose/_docker-compose

  # Brew completions
  zinit ice wait"0b" lucid blockf


  # Brew completions
  if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

    autoload -Uz compinit
    compinit
  fi

  # Zsh completions
  zinit light zsh-users/zsh-completions

  # Zsh OMZ libraries
  zinit snippet OMZL::clipboard.zsh
  zinit snippet OMZL::compfix.zsh
  zinit snippet OMZL::correction.zsh
  zinit snippet OMZL::completion.zsh
  zinit snippet OMZL::grep.zsh
  zinit snippet OMZL::history.zsh
  zinit snippet OMZL::spectrum.zsh

  # Zsh OMZ plugins
  zinit snippet OMZP::asdf
  # zinit snippet OMZP::fzf

  zinit light hlissner/zsh-autopair

  # Fast highlight
  # @see https://github.com/zdharma-continuum/fast-syntax-highlighting?tab=readme-ov-file#zinit
  zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
    blockf \
    zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

  # Install also as a zsh plugin
  if [ -n "$LAPTOP_GIT_REMOTE" ]; then
    zinit light "$LAPTOP_GIT_REMOTE"
  fi
fi
