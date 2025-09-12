#!/usr/bin/env bash

laptop_ensure_package__android-sdk() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    brew remove android-sdk &>/dev/null
    laptop_ensure_package_default "android-commandlinetools"
  else
    laptop_step_start "- Ensure android-sdk installed (via git)"
    laptop_step_eval "echo >&2 Not implemented;exit 1;"
  fi

  # Install Android tools
  laptop_ensure_sdkmanager_package "platforms;android-34"
  laptop_ensure_sdkmanager_package "build-tools;34.0.0"
  laptop_ensure_sdkmanager_package "cmdline-tools;16.0"
}
