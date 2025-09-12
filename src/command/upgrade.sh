#!/usr/bin/env bash

__LAPTOP_UPGRADE_TOOLS=("brew" "zinit" "asdf" "code" "sdkmanager" "softwareupdate")

laptop_command__upgrade_detect() {
  local filtered_commands
  filtered_commands=$(laptop_filter_command_exists "${__LAPTOP_UPGRADE_TOOLS[@]}")
  echo "The following tools were found and will be upgraded :"
  echo ""
  echo "  ✓ laptop (itself)"
  # Iterate over the tools and check for their existence
  for tool in ${filtered_commands}; do
    echo "  ✓ $tool"
  done
  echo ""
}

laptop_command__upgrade_run() {
  laptop_ensure_license_accepted

  local filtered_commands
  filtered_commands=$(laptop_filter_command_exists "${__LAPTOP_UPGRADE_TOOLS[@]}")
  for tool in $filtered_commands; do
    case "$tool" in
    apt-get)
      laptop_ensure_apt_updated
      ;;
    asdf)
      laptop_ensure_asdf_updated
      ;;
    brew)
      laptop_ensure_brew_updated
      ;;
    code)
      laptop_ensure_vscode_updated
      ;;
    sdkmanager)
      laptop_ensure_sdkmanager_updated
      ;;
    softwareupdate)
      laptop_step_start "- Upgrade macOS"
      echo ''
      softwareupdate --install --all
      ;;
    zinit)
      laptop_ensure_zinit_updated
      ;;
    *)
      echo "Unknown tool: $tool"
      ;;
    esac
  done
}

laptop_command__upgrade() {
  laptop_logo
  laptop_command__upgrade_detect
  if laptop_confirm "Continue? (Y/n)"; then
    laptop_command__upgrade_run

    laptop_info "🎉 Upgrade successful"
  else
    laptop_error "🛑 Upgrade aborted"
    exit 1
  fi
}
