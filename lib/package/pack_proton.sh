#!/usr/bin/env bash

laptop_require "laptop_package_ensure_default"

laptop_package_ensure__pack:proton() {
  laptop_package_ensure_default "proton-mail"
  laptop_package_ensure_default "proton-drive"
  laptop_package_ensure_default "proton-pass"
  laptop_package_ensure_default "protonvpn"
}
