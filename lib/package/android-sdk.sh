#!/usr/bin/env bash

laptop_require "laptop_brew_ensure_package"
laptop_require "laptop_androidsdk_ensure_package"
laptop_require "laptop_sdkmanager_ensure_package"
laptop_require "laptop_step_start"
laptop_require "laptop_step_eval"

laptop_package_ensure__android-sdk() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_brew_ensure_package android-sdk --status absent
    if command -v sdkmanager >/dev/null 2>&1; then
      laptop_sdkmanager_ensure_package "cmdline-tools;latest" --status absent
    fi
    laptop_brew_ensure_package android-commandlinetool --status absent
    laptop_brew_ensure_package "android-cli" "$@"
  else
    laptop_step_start "- Ensure android-sdk installed (via git)"
    laptop_step_eval "echo >&2 Not implemented;exit 1;"
  fi

  # Install Android tools
  laptop_androidsdk_ensure_package "platforms;android-34"
  laptop_androidsdk_ensure_package "build-tools;34.0.0"
  # laptop_androidsdk_ensure_package "cmdline-tools;latest" // Not needed ?
}
