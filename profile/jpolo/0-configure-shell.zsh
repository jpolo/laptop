#!/usr/bin/env zsh

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
ROOT_DIR=$(dirname $(dirname "$SCRIPT_DIR"))
source "$ROOT_DIR/src/_functions.sh"
source "$ROOT_DIR/src/function/source_all.sh"
laptop::source_all "$ROOT_DIR/src/function"

# Migrate
rm -rf "$XDG_DATA_HOME/zsh/00_init.sh"
if [  -f "$XDG_DATA_HOME/zsh/01_custom.sh" ];then
  mv "$XDG_DATA_HOME/zsh/01_custom.sh" "$XDG_DATA_HOME/zsh/personal.sh"
fi

# Ensure ZSH Configuration
if [ ! -f "$HOME/.zshrc.local" ];then
  laptop::ensure_file_template "resource/zshrc.local" "$HOME/.zshrc.local"
fi
laptop::ensure_file_template "resource/zshrc.d/global.sh" "$XDG_DATA_HOME/zsh/global.sh"
laptop::ensure_file_template "resource/zshrc.d/organization.sh" "$XDG_DATA_HOME/zsh/organization.sh"
if [ ! -f "$XDG_DATA_HOME/zsh/personal.sh" ];then
  laptop::ensure_file_template "resource/zshrc.d/personal.sh" "$XDG_DATA_HOME/zsh/personal.sh"
fi
if [ ! -f "${POWERLEVEL9K_CONFIG_FILE:-$XDG_CONFIG_HOME/zsh/p10k.zsh}" ];then
  laptop::ensure_file_template "resource/p10k.zsh" "${POWERLEVEL9K_CONFIG_FILE:-$XDG_CONFIG_HOME/zsh/p10k.zsh}"
fi
