#!/usr/bin/env bash

laptop::ensure_brew_updated() {
  laptop::step_start "- Upgrade brew"
  laptop::step_eval "brew upgrade --quiet"
}
