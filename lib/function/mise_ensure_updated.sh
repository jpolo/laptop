#!/usr/bin/env bash

laptop_require "laptop_step_upgrade_start"
laptop_require "laptop_step_status"
laptop_require "laptop_step_exec"

laptop_mise_ensure_updated() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_step_upgrade_start "mise is managed by Homebrew"
    laptop_step_status "pass"
  else
    laptop_step_upgrade_start "mise updated"
    if mise self-update --yes; then
      laptop_step_status "ok"
    else
      laptop_step_status "fail"
      return 1
    fi
  fi
}
