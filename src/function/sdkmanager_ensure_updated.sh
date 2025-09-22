#!/usr/bin/env bash

laptop_sdkmanager_ensure_updated() {
  laptop_step_start "- Upgrade sdkmanager"
  laptop_step_eval "yes | sdkmanager --licenses && sdkmanager --update"
}
