#!/usr/bin/env bash

# Ensure asdf packages are up to date
#
# Usage:
#   laptop_asdf_ensure_updated
#
laptop_asdf_ensure_updated() {
  laptop_step_start "- Upgrade asdf"
  laptop_step_eval "asdf plugin update --all"
}
