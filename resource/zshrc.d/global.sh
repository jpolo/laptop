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

if command -v zi &> /dev/null; then
  # When zi is available
  zi ice depth=1
  zi light romkatv/powerlevel10k

  # zi ice nocompile:! pick:c.zsh atpull:%atclone atclone:'dircolors -b LS_COLORS > c.zsh'
  # zi light trapd00r/LS_COLORS

  # Fish like suggestions
  zi ice wait"0a" lucid atload"_zsh_autosuggest_start"
  zi light zsh-users/zsh-autosuggestions

  zi ice wait:0a lucid atload'bindkey "$terminfo[kcuu1]" history-substring-search-up; bindkey "$terminfo[kcud1]" history-substring-search-down'
  zi light zsh-users/zsh-history-substring-search

  ##
  # Completions
  ##

  # Brew completions
  zi ice wait"0b" lucid blockf
  # Brew completions
  if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

    autoload -Uz compinit
    compinit
  fi

  # Zsh completions
  zi light zsh-users/zsh-completions

  # Zsh OMZ libraries
  zi snippet OMZL::clipboard.zsh
  zi snippet OMZL::compfix.zsh
  zi snippet OMZL::correction.zsh
  zi snippet OMZL::completion.zsh
  zi snippet OMZL::grep.zsh
  zi snippet OMZL::history.zsh
  # zi snippet OMZL::spectrum.zsh

  # Zsh OMZ plugins
  zi snippet OMZP::asdf
  # zi snippet OMZP::fzf

  zi light hlissner/zsh-autopair

  zi ice silent wait:0c atload"ZI[COMPINIT_OPTS]=-C; zpcompinit"
  zi light zdharma-continuum/fast-syntax-highlighting

  # Install also as a zsh plugin
  zi light jpolo/laptop
fi
