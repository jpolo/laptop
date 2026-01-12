#!/usr/bin/env bash

laptop_require "laptop_confirm"
laptop_require "laptop_die"
laptop_require "laptop_handler_call"
laptop_require "laptop_log"
laptop_require "laptop_step_upgrade_start"
laptop_require "laptop_self_ensure_updated"
laptop_require "laptop_brew_ensure_updated"
laptop_require "laptop_asdf_ensure_updated"
laptop_require "laptop_sdkmanager_ensure_updated"
laptop_require "laptop_vscode_ensure_updated"
laptop_require "laptop_xcode_ensure_license_accepted"
laptop_require "laptop_zinit_ensure_updated"
laptop_require "laptop_apt_ensure_updated"
laptop_require "laptop_filter_command_exists"

__LAPTOP_UPGRADE_TOOLS=("laptop" "brew" "zinit" "asdf" "npm" "code" "cursor" "sdkmanager" "softwareupdate")

laptop_command__upgrade_detect() {
  local filtered_commands
  filtered_commands=$(laptop_filter_command_exists "${__LAPTOP_UPGRADE_TOOLS[@]}")
  echo "The following tools were found and will be upgraded :"
  echo ""
  # Iterate over the tools and check for their existence
  for tool in ${filtered_commands}; do
    echo "  ✓ $tool"
  done
  echo ""
}

laptop_command__upgrade_run() {
  laptop_xcode_ensure_license_accepted

  local filtered_commands
  filtered_commands=$(laptop_filter_command_exists "${__LAPTOP_UPGRADE_TOOLS[@]}")
  for tool in $filtered_commands; do
    case "$tool" in
    apt-get)
      laptop_apt_ensure_updated
      ;;
    asdf)
      laptop_asdf_ensure_updated
      ;;
    npm)
      laptop_npm_ensure_updated
      ;;
    brew)
      laptop_brew_ensure_updated
      ;;
    code)
      LAPTOP_VSCODE_EXECUTABLE="$tool" laptop_vscode_ensure_updated
      ;;
    cursor)
      LAPTOP_VSCODE_EXECUTABLE="$tool" laptop_vscode_ensure_updated
      ;;
    laptop)
      laptop_self_ensure_updated
      ;;
    sdkmanager)
      laptop_sdkmanager_ensure_updated
      ;;
    softwareupdate)
      laptop_step_upgrade_start "macOS updated"
      echo ''
      softwareupdate --install --all
      ;;
    zinit)
      laptop_zinit_ensure_updated
      ;;
    *)
      echo "Unknown tool: $tool"
      ;;
    esac
  done
}

laptop_command__upgrade() {
  laptop_handler_call "logo"
  laptop_command__upgrade_detect
  if laptop_confirm "Continue? (y/N)"; then
    laptop_command__upgrade_run

    laptop_log info "🎉 Upgrade successful"
  else
    laptop_die "🛑 Upgrade aborted"
  fi
}
