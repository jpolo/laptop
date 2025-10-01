#!/usr/bin/env bash

laptop_xcode_ensure_license_accepted() {
  local xcode_message="xcodebuild license accepted"
  if laptop_command_exists "xcodebuild"; then
    laptop_step_start_status "present" "unknown" "$xcode_message"
    if ! [[ "$(/usr/bin/xcrun clang 2>&1 || true)" =~ 'license' ]]; then
      # Already approved
      laptop_step_ok
    else
      if sudo xcodebuild -license accept; then
        laptop_step_ok
      else
        laptop_step_fail
      fi
    fi
  fi
}
