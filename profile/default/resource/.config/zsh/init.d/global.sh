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
  zinit wait lucid for \
    atload'bindkey "^[[A" history-substring-search-up; bindkey "^[[B" history-substring-search-down' \
    zsh-users/zsh-history-substring-search

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

  # Brew completions (use cached HOMEBREW_PREFIX, compinit handled by zicompinit)
  if type brew &>/dev/null; then
    : "${HOMEBREW_PREFIX:=$(brew --prefix)}"
    FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:$FPATH"
  fi

  # Zsh OMZ libraries
  # History loaded immediately (needed for shell behavior)
  zinit snippet OMZL::history.zsh

  # Non-essential libraries deferred
  zinit wait lucid for \
    OMZL::clipboard.zsh \
    OMZL::compfix.zsh \
    OMZL::correction.zsh \
    OMZL::grep.zsh \
    OMZL::spectrum.zsh
  # OMZL::completion.zsh - DISABLED: calls compinit internally, conflicts with zicompinit below

  # Zsh OMZ plugins
  zinit snippet OMZP::asdf
  # zinit snippet OMZP::fzf

  zinit wait lucid for \
    hlissner/zsh-autopair

  # Fast highlight
  # @see https://github.com/zdharma-continuum/fast-syntax-highlighting?tab=readme-ov-file#zinit
  zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
    OMZ::plugins/colored-man-pages
fi
