#!/usr/bin/env bash

laptop_ensure_package__pack:proton() {
  laptop_ensure_package_default "proton-mail"
  laptop_ensure_package_default "proton-drive"
  laptop_ensure_package_default "proton-pass"
  laptop_ensure_package_default "protonvpn"
}
