#!/usr/bin/env bash

laptop::ensure_package__pack:core() {
  # A pack of required packages

  # Install core tools
  laptop::ensure_package "coreutils"
  laptop::ensure_package "moreutils"
  laptop::ensure_package "findutils"
  laptop::ensure_package "asdf"
  laptop::ensure_package "curl"
  laptop::ensure_package "git"
  laptop::ensure_package "gnutls"
  laptop::ensure_package "gnupg"
  laptop::ensure_package "mercurial"
  laptop::ensure_package "gpg"
  laptop::ensure_package "jq"
  laptop::ensure_package "rclone"
  laptop::ensure_package "webp"
  laptop::ensure_package "wget"

  # Install library
  laptop::ensure_package "graphviz"
  laptop::ensure_package "imagemagick"
  laptop::ensure_package "libpq"
  laptop::ensure_package "libyaml"
  laptop::ensure_package "libvips"
  laptop::ensure_package "openssl"
}
