#!/usr/bin/env bash

laptop_require "laptop_package_ensure"

laptop_package_ensure__pack:core() {
  # A pack of required packages

  # Install core tools
  laptop_package_ensure "augeas"
  laptop_package_ensure "coreutils"
  laptop_package_ensure "moreutils"
  laptop_package_ensure "findutils"
  laptop_package_ensure "curl"

  for tool in "asdf" "mise"; do
    if [ "$LAPTOP_TOOL_MANAGER" = "$tool" ]; then
      laptop_package_ensure "$tool" --status present
    else
      laptop_package_ensure "$tool" --status absent
    fi
  done
  laptop_package_ensure "git"
  laptop_package_ensure "gnutls"
  laptop_package_ensure "gnupg"
  laptop_package_ensure "mercurial"
  laptop_package_ensure "gpg"
  laptop_package_ensure "jq"
  laptop_package_ensure "rclone"
  laptop_package_ensure "uv"
  laptop_package_ensure "webp"
  laptop_package_ensure "wget"

  # Install library
  laptop_package_ensure "graphviz"
  laptop_package_ensure "imagemagick"
  laptop_package_ensure "libpq"
  laptop_package_ensure "mysql-client"
  laptop_package_ensure "libyaml"
  # Global libvips conflicts with npm sharp
  laptop_package_ensure "libvips" --status absent
  laptop_package_ensure "openssl"
}
