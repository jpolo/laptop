#!/usr/bin/env bash

# Returns the system uptime in seconds.
#
# Usage: laptop_uptime
laptop_uptime() {
  local up_seconds
  if [ "$(uname -s)" = "Darwin" ]; then
    local boot_seconds now
    boot_seconds="$(sysctl -n kern.boottime | sed -E 's/.*sec = ([0-9]+).*/\1/')"
    now="$(laptop_date_to_epoch "$(laptop_date_now)")"
    up_seconds=$((now - boot_seconds))
  else
    up_seconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
  fi
  echo "$up_seconds"
}
