#!/usr/bin/env zsh

source "$LAPTOP_HOME/src/env.sh"
LAPTOP_PROFILE_DEFAULT_DIR=$(laptop_profile_dir default)
LAPTOP_PROFILE_CURRENT_DIR=$(laptop_profile_dir)

# Ensure ZSH Configuration
laptop_ensure_file_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/zshrc.d/global.sh" "$XDG_DATA_HOME/zsh/global.sh" --force
laptop_ensure_file_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/zshrc.d/personal.sh" "$XDG_DATA_HOME/zsh/personal.sh"
laptop_ensure_file_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/starship.toml" "${STARSHIP_CONFIG:-$XDG_CONFIG_HOME/starship/config.toml}"

