#!/usr/bin/env bash

ensure_package__pack:core() {
  # A pack of required packages

  # Install core tools
  ensure_package "coreutils"
  ensure_package "moreutils"
  ensure_package "findutils"
  ensure_package "asdf"
  ensure_package "curl"
  ensure_package "git"
  ensure_package "gnutls"
  ensure_package "gnupg"
  ensure_package "mercurial"
  ensure_package "gpg"
  ensure_package "jq"
  ensure_package "rclone"
  ensure_package "webp"
  ensure_package "wget"
  ensure_package "yarn"

  # Install library
  ensure_package "graphviz"
  ensure_package "imagemagick"
  ensure_package "libpq"
  ensure_package "libyaml"
  ensure_package "libvips"
  ensure_package "openssl"
}
