#!/usr/bin/env bash

laptop_require "laptop_package_ensure"
laptop_require "laptop_asdf_ensure_plugin"

laptop_package_ensure__pack:core() {
  # A pack of required packages

  # Install core tools
  laptop_package_ensure "augeas"
  laptop_package_ensure "coreutils"
  laptop_package_ensure "moreutils"
  laptop_package_ensure "findutils"
  laptop_package_ensure "asdf"
  laptop_package_ensure "curl"
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
  laptop_package_ensure "libvips"
  laptop_package_ensure "openssl"

  laptop_package_ensure "config:asdf-recommended"
}
