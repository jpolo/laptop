#!/usr/bin/env bash

laptop_xcode_ensure_license_accepted() {
  local xcode_message="- Ensure xcodebuild license accepted"
  if laptop_command_exists "xcodebuild"; then
    if ! [[ "$(/usr/bin/xcrun clang 2>&1 || true)" =~ 'license' ]]; then
      # Already approved
      laptop_step_start "$xcode_message"
      laptop_step_ok
    else
      laptop_step_start "$xcode_message\n"
      if sudo xcodebuild -license accept; then
        laptop_step_ok
      else
        laptop_step_fail
      fi
    fi
  fi
}
