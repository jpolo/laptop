#!/usr/bin/env bash

laptop::ensure_license_accepted() {
  local xcode_message="- Ensure xcodebuild license accepted"
  if laptop::command_exists "xcodebuild"; then
    if ! [[ "$(/usr/bin/xcrun clang 2>&1 || true)" =~ 'license' ]]; then
      # Already approved
      laptop::step_start "$xcode_message"
      laptop::step_ok
    else
      laptop::step_start "$xcode_message\n"
      if sudo xcodebuild -license accept; then
        laptop::step_ok
      else
        laptop::step_fail
      fi
    fi
  fi
}
