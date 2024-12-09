#!/usr/bin/env bash

laptop::self_check_version() {
  if laptop::self_updated; then
    laptop::warn "A new laptop version is available. Run 'laptop upgrade' to download it."
  else
    laptop::info "✓ laptop is up to date"
  fi
}
