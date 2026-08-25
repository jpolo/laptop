#!/usr/bin/env bash

# Get the current date in UTC format (YYYY-MM-DDTHH:MM:SSZ)
#
# Usage:
#   laptop_date_now
laptop_date_now() {
  # for mocking
  if [ -n "$LAPTOP_DATE_NOW" ]; then
    echo "$LAPTOP_DATE_NOW"
    return
  fi

  # default implementation
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}
