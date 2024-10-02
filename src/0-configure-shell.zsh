#!/usr/bin/env zsh

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/_functions.sh"
source "$SCRIPT_DIR/function/source_all.sh"
laptop::source_all "$SCRIPT_DIR/function"

# Migrate
rm -rf "$XDG_DATA_HOME/zsh/00_init.sh"
if [  -f "$XDG_DATA_HOME/zsh/01_custom.sh" ];then
  mv "$XDG_DATA_HOME/zsh/01_custom.sh" "$XDG_DATA_HOME/zsh/personal.sh"
fi

# Ensure ZSH Configuration
if [ ! -f "$HOME/.zshrc.local" ];then
  laptop::ensure_file_template "zshrc.local" "$HOME/.zshrc.local"
fi
laptop::ensure_file_template "zshrc.d/global.sh" "$XDG_DATA_HOME/zsh/global.sh"
laptop::ensure_file_template "zshrc.d/organization.sh" "$XDG_DATA_HOME/zsh/organization.sh"
if [ ! -f "$XDG_DATA_HOME/zsh/personal.sh" ];then
  laptop::ensure_file_template "zshrc.d/personal.sh" "$XDG_DATA_HOME/zsh/personal.sh"
fi
if [ ! -f "${POWERLEVEL9K_CONFIG_FILE:-$XDG_CONFIG_HOME/zsh/p10k.zsh}" ];then
  laptop::ensure_file_template "p10k.zsh" "${POWERLEVEL9K_CONFIG_FILE:-$XDG_CONFIG_HOME/zsh/p10k.zsh}"
fi
