#!/usr/bin/env bash

# Ensure asdf packages are up to date
#
# Usage:
#   laptop::ensure_asdf_updated
#
laptop::ensure_asdf_updated() {
  laptop::step_start "- Upgrade asdf"
  laptop::step_eval "asdf plugin update --all"
}
