#!/usr/bin/env bash

laptop_ensure_sdkmanager_package() {
  local package="$1"
  laptop_step_start "- Ensure sdkmanager '$package'"
  laptop_step_eval "sdkmanager --install '$package'"
}
