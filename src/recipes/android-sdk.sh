#!/usr/bin/env bash

laptop_package_ensure__android-sdk() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    brew remove android-sdk &>/dev/null
    laptop_package_ensure_default "android-commandlinetools"
  else
    laptop_step_start "- Ensure android-sdk installed (via git)"
    laptop_step_eval "echo >&2 Not implemented;exit 1;"
  fi

  # Install Android tools
  laptop_sdkmanager_ensure_package "platforms;android-34"
  laptop_sdkmanager_ensure_package "build-tools;34.0.0"
  laptop_sdkmanager_ensure_package "cmdline-tools;16.0"
}
