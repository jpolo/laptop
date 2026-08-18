#!/usr/bin/env bash

# Convert a UTC ISO timestamp to Unix epoch seconds.
#
# Usage:
#   laptop_date_to_epoch <timestamp>
laptop_date_to_epoch() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    date -j -u -f "%Y-%m-%dT%H:%M:%SZ" "$1" "+%s" 2>/dev/null
  else
    date -u -d "$1" "+%s" 2>/dev/null
  fi
}
