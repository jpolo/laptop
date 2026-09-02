#!/usr/bin/env bash

# Returns the system uptime in seconds.
#
# Usage: laptop_uptime
laptop_uptime() {
  local up_seconds
  if [ "$(uname -s)" = "Darwin" ]; then
    local boot_seconds now
    # Output looks like: { sec = 1788257275, usec = 196255 } Tue Sep  1 12:07:55 2026
    # Anchor on the first number so the greedy match does not pick up "usec".
    boot_seconds="$(sysctl -n kern.boottime | sed -E 's/^[^0-9]*([0-9]+).*/\1/')"
    now="$(laptop_date_to_epoch "$(laptop_date_now)")"
    up_seconds=$((now - boot_seconds))
  else
    up_seconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
  fi
  echo "$up_seconds"
}

