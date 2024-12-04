#!/usr/bin/env bash

laptop::ensure_asdf_updated() {
  laptop::step_start "- Upgrade asdf"
  laptop::step_eval "asdf plugin update --all"
}
