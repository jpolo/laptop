# shellcheck disable=SC2148
#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯
# ZSH startup script : specific config
#
# 🔒🚨 Warning : this file was automatically generated, editing it is not recommended
#⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯

if command -v zinit &>/dev/null; then
  ##
  # Starship Theme
  ##
  zinit ice as"command" from"gh-r" \
    atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
    atpull"%atclone" src"init.zsh"
  zinit light starship/starship

  # zinit ice nocompile:! pick:c.zsh atpull:%atclone atclone:'dircolors -b LS_COLORS > c.zsh'
  # zinit light trapd00r/LS_COLORS

  # Fish like suggestions
  zinit wait lucid for \
    atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

  # History Substring Search
  # shellcheck disable=SC2016
  zinit load 'zsh-users/zsh-history-substring-search'
  zinit ice wait atload'_history_substring_search_config'
  # Bind keys
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down

  # Completions
  ##

  # ZSH community completions
  zinit wait lucid for \
    blockf \
    zsh-users/zsh-completions

  # Docker completion
  zinit wait lucid light-mode has"docker" for \
    as"completion" OMZ::plugins/docker/completions/_docker \
    as'completion' OMZ::plugins/docker-compose/_docker-compose

  # Brew completions
  if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
    autoload -Uz compinit && compinit
  fi

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
    OMZ::plugins/colored-man-pages

  # Install also as a zsh plugin
  if [ -n "$LAPTOP_GIT_REMOTE" ]; then
    zinit light "$LAPTOP_GIT_REMOTE"
  fi
fi
