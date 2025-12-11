#!/usr/bin/env bash

laptop_require "laptop_log"

# Stop execution with a message
#
# Usage:
#   laptop_die <message>
#
# Example:
#   laptop_die "This is an error message"
#
laptop_die() {
  laptop_log error "$1"
  exit 1
}
