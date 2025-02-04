#!/usr/bin/env bash

__LAPTOP_UPGRADE_TOOLS=("brew" "zinit" "asdf" "code" "sdkmanager" "softwareupdate")

laptop::command__upgrade_detect() {
  local filtered_commands
  filtered_commands=$(laptop::filter_command_exists "${__LAPTOP_UPGRADE_TOOLS[@]}")
  echo "The following tools were found and will be upgraded :"
  echo ""
  echo "  ✓ laptop (itself)"
  # Iterate over the tools and check for their existence
  for tool in ${filtered_commands}; do
    echo "  ✓ $tool"
  done
  echo ""
}

laptop::command__upgrade_run() {
  laptop::ensure_license_accepted

  local filtered_commands
  filtered_commands=$(laptop::filter_command_exists "${__LAPTOP_UPGRADE_TOOLS[@]}")
  for tool in $filtered_commands; do
    case "$tool" in
    apt-get)
      laptop::ensure_apt_updated
      ;;
    asdf)
      laptop::ensure_asdf_updated
      ;;
    brew)
      laptop::ensure_brew_updated
      ;;
    code)
      laptop::ensure_vscode_updated
      ;;
    sdkmanager)
      laptop::ensure_sdkmanager_updated
      ;;
    softwareupdate)
      laptop::step_start "- Upgrade macOS"
      echo ''
      softwareupdate --install --all
      ;;
    zinit)
      laptop::ensure_zinit_updated
      ;;
    *)
      echo "Unknown tool: $tool"
      ;;
    esac
  done
}

laptop::command__upgrade() {
  laptop::logo
  laptop::command__upgrade_detect
  if laptop::confirm "Continue? (Y/n)"; then
    laptop::command__upgrade_run

    laptop::info "🎉 Upgrade successful"
  else
    laptop::error "🛑 Upgrade aborted"
    exit 1
  fi
}
