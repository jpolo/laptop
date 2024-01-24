#!/usr/bin/env zsh

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/_functions.sh"

# Migrate
rm -rf "$XDG_DATA_HOME/zsh/00_init.sh"
mv "$XDG_DATA_HOME/zsh/01_custom.sh" "$XDG_DATA_HOME/zsh/personal.sh" &2>/dev/null || true

# Ensure ZSH Configuration
ensure_file_template "zshrc.d/global.sh" "$XDG_DATA_HOME/zsh/global.sh"
ensure_file_template "zshrc.d/organization.sh" "$XDG_DATA_HOME/zsh/organization.sh"
if [ ! -f "$XDG_DATA_HOME/zsh/personal.sh" ];then
  ensure_file_template "zshrc.d/personal.sh" "$XDG_DATA_HOME/zsh/personal.sh"
fi
if [ ! -f "${POWERLEVEL9K_CONFIG_FILE:-$XDG_CONFIG_HOME/zsh/p10k.zsh}" ];then
  ensure_file_template "p10k.zsh" "${POWERLEVEL9K_CONFIG_FILE:-$XDG_CONFIG_HOME/zsh/p10k.zsh}"
fi
