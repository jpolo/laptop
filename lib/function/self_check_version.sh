#!/usr/bin/env bash

laptop_self_check_version() {
  if laptop_self_updated; then
    laptop_log info "Laptop is up to date"
  else
    laptop_log warn "A new laptop version is available. Run 'laptop upgrade' to download it."
  fi
}
