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
zinit ice depth=1
zinit light romkatv/powerlevel10k

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

# Homebrew completions
zinit for \
    as'null' \
    atclone'%atpull' \
    atpull'
         ./bin/brew update --preinstall \
      && ln -sf $PWD/completions/zsh/_brew $ZINIT[COMPLETIONS_DIR] \
      && rm -f brew.zsh \
      && ./bin/brew shellenv --dummy-arg > brew.zsh \
      && zcompile brew.zsh' \
    depth'3' \
    nocompletions \
    sbin'bin/brew' \
    src'brew.zsh' \
  homebrew/brew

# gh (github cli) completions
zi for \
    from'gh-r' \
    sbin'**/gh' \
  cli/cli

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

zinit ice silent wait:0c atload"ZINIT[COMPINIT_OPTS]=-C; zpcompinit"
zinit light zdharma-continuum/fast-syntax-highlighting

# Install also as a zsh plugin
zinit light jpolo/laptop
