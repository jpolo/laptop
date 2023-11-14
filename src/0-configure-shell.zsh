#!/usr/bin/env zsh

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/_functions.sh"

# Ensure ZSH Configuration
ensure_file_template "zshrc.d/00_init.sh" "$XDG_DATA_HOME/zsh/00_init.sh"
if [ ! -f "$XDG_DATA_HOME/zsh/01_custom.sh" ];then
  ensure_file_template "zshrc.d/01_custom.sh" "$XDG_DATA_HOME/zsh/01_custom.sh"
fi
if [ ! -f "${POWERLEVEL9K_CONFIG_FILE:-$XDG_CONFIG_HOME/zsh/p10k.zsh}" ];then
  ensure_file_template "p10k.zsh" "${POWERLEVEL9K_CONFIG_FILE:-$XDG_CONFIG_HOME/zsh/p10k.zsh}"
fi
