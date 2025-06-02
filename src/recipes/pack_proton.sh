#!/usr/bin/env bash

laptop::ensure_package__pack:proton() {
  laptop::ensure_package_default "proton-mail"
  laptop::ensure_package_default "proton-drive"
  laptop::ensure_package_default "proton-pass"
  laptop::ensure_package_default "protonvpn"
}
