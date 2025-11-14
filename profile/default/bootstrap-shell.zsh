#!/usr/bin/env zsh

source "$LAPTOP_HOME/lib/env.sh"
LAPTOP_PROFILE_DEFAULT_DIR=$(laptop_profile_dir default)

# Ensure ZSH Configuration
laptop_file_ensure_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/zshrc.d/global.sh" "$XDG_DATA_HOME/zsh/global.sh" --force
laptop_file_ensure_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/zshrc.d/personal.sh" "$XDG_DATA_HOME/zsh/personal.sh"
laptop_shell_profile_var "LAPTOP_CONFIG_FILE" '"$XDG_DATA_HOME/zsh/personal.sh"'
laptop_file_ensure_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/starship.toml" "${STARSHIP_CONFIG:-$XDG_CONFIG_HOME/starship/config.toml}"

