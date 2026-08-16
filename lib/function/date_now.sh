#!/usr/bin/env bash

# Get the current date in UTC format (YYYY-MM-DDTHH:MM:SSZ)
#
# Usage:
#   laptop_date_now
laptop_date_now() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}
