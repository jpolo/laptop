#!/usr/bin/env zsh

source "$LAPTOP_HOME/src/env.sh"
LAPTOP_PROFILE_DEFAULT_DIR=$(laptop::profile_dir default)
LAPTOP_PROFILE_CURRENT_DIR=$(laptop::profile_dir)

# Ensure ZSH Configuration
if [ ! -f "$HOME/.zshrc.local" ];then
  laptop::ensure_file_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/zshrc.local" "$HOME/.zshrc.local"
fi
laptop::ensure_file_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/zshrc.d/global.sh" "$XDG_DATA_HOME/zsh/global.sh"
if [ ! -f "$XDG_DATA_HOME/zsh/personal.sh" ];then
  laptop::ensure_file_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/zshrc.d/personal.sh" "$XDG_DATA_HOME/zsh/personal.sh"
fi
if [ ! -f "${STARSHIP_CONFIG:-$XDG_CONFIG_HOME/starship/config.toml}" ];then
  laptop::ensure_file_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/starship.toml" "${STARSHIP_CONFIG:-$XDG_CONFIG_HOME/starship/config.toml}"
fi
