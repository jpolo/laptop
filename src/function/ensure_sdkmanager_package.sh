#!/usr/bin/env bash

laptop::ensure_sdkmanager_package() {
  local package="$1"
  laptop::step_start "- Ensure sdkmanager '$package'"
  laptop::step_eval "sdkmanager --install '$package'"
}
