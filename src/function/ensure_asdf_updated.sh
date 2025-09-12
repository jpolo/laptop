#!/usr/bin/env bash

# Ensure asdf packages are up to date
#
# Usage:
#   laptop_ensure_asdf_updated
#
laptop_ensure_asdf_updated() {
  laptop_step_start "- Upgrade asdf"
  laptop_step_eval "asdf plugin update --all"
}
