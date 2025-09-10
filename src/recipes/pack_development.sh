#!/usr/bin/env bash

laptop::ensure_package__pack:development() {
  # laptop::ensure_package "chromedriver" // DEPRECATED
  laptop::ensure_package "docker"
  laptop::ensure_package "iterm2"
  laptop::ensure_package "mysql"
  laptop::ensure_package "pgadmin4"
  laptop::ensure_package "postman"
  laptop::ensure_package "virtualbox"
  laptop::ensure_package "visual-studio-code"

  # Fonts for development
  laptop::ensure_package "font-monaspace"
}
