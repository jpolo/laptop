#!/usr/bin/env bash

laptop::self_check_version() {
  if laptop::self_updated; then
    laptop::info "Laptop is up to date"
  else
    laptop::warn "A new laptop version is available. Run 'laptop upgrade' to download it."
  fi
}
