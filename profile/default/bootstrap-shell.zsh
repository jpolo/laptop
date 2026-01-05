#!/usr/bin/env zsh

laptop_require "laptop_profile_dir"
laptop_require "laptop_file_ensure_template"
laptop_require "laptop_xdg_dir"

LAPTOP_PROFILE_DEFAULT_DIR=$(laptop_profile_dir default)

# Ensure ZSH Configuration
laptop_file_ensure_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/starship.toml" "${STARSHIP_CONFIG:-$(laptop_xdg_dir "config")/starship/config.toml}"
laptop_file_ensure_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/.config/zsh/init" "$(laptop_xdg_dir "config")/zsh/init"
laptop_file_ensure_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/.config/zsh/init.d/global.sh" "$(laptop_xdg_dir "data")/zsh/init.d/global.sh" --force
laptop_file_ensure_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/.config/zsh/profile" "$(laptop_xdg_dir "config")/zsh/profile"

