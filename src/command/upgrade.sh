#!/usr/bin/env bash

__LAPTOP_UPGRADE_TOOLS=("brew" "zi" "asdf" "code" "sdkmanager" "softwareupdate")

__program_upgrade_detect() {
  local filtered_commands=$(filter_command_exists "${__LAPTOP_UPGRADE_TOOLS[@]}")
  echo "The following tools were found and will be upgraded :"
  echo ""
  # Iterate over the tools and check for their existence
  for tool in ${filtered_commands}; do
    echo "  ✓ $tool"
  done
  echo ""
}

__program_upgrade_run() {
  ensure_license_accepted

  local filtered_commands=$(filter_command_exists "${__LAPTOP_UPGRADE_TOOLS[@]}")
  for tool in $filtered_commands; do
    case "$tool" in
      apt-get)
        ensure_apt_updated
        ;;
      asdf)
        ensure_asdf_updated
        ;;
      brew)
        ensure_brew_updated
        ;;
      code)
        ensure_vscode_updated
        ;;
      sdkmanager)
        ensure_sdkmanager_updated
        ;;
      softwareupdate)
        _laptop_step_start "- Upgrade macOS"
        echo ''
        softwareupdate --install --all
        ;;
      zi)
        ensure_zi_updated
        ;;
      *)
        echo "Unknown tool: $tool"
        ;;
    esac
  done
}

__program_upgrade() {
  _laptop-logo
  __program_upgrade_detect
  if confirm "Continue? (Y/n)"; then
    __program_upgrade_run

    einfo "🎉 Upgrade successful"
  else
    eerror "🛑 Upgrade aborted"
    exit 1
  fi
}
