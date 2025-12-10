#!/usr/bin/env zsh

source "$LAPTOP_HOME/lib/init.sh"
LAPTOP_PROFILE_DEFAULT_DIR=$(laptop_profile_dir default)

# Ensure ZSH Configuration
laptop_file_ensure_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/zshrc.d/global.sh" "$(laptop_xdg_dir "data")/zsh/global.sh" --force
laptop_file_ensure_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/zshrc.d/personal.sh" "$(laptop_xdg_dir "data")/zsh/personal.sh"
laptop_shell_profile_var "LAPTOP_CONFIG_ZSH_FILE" '"$XDG_DATA_HOME/zsh/personal.sh"'
laptop_file_ensure_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/starship.toml" "${STARSHIP_CONFIG:-$(laptop_xdg_dir "config")/starship/config.toml}"

