#!/usr/bin/env bash

ensure_package__android-sdk() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    brew remove android-sdk &>/dev/null
    brew remove android-commandlinetools &>/dev/null
    # ensure_package_default "android-commandlinetools"
  else
    _laptop_step_start "- Ensure android-sdk installed (via git)"
    _laptop_step_eval "echo >&2 Not implemented;exit 1;"
  fi
}
