#!/usr/bin/env bash

laptop_sdkmanager_ensure_updated() {
  laptop_step_upgrade_start "sdkmanager updated"
  laptop_step_eval "yes | sdkmanager --licenses && sdkmanager --update"
}
