#!/usr/bin/env bash

laptop_ensure_package__pack:development() {
  # laptop_ensure_package "chromedriver" // DEPRECATED
  laptop_ensure_package "docker"
  laptop_ensure_package "iterm2"
  laptop_ensure_package "mysql"
  laptop_ensure_package "pgadmin4"
  laptop_ensure_package "postman"
  laptop_ensure_package "virtualbox"
  laptop_ensure_package "visual-studio-code"

  # Fonts for development
  laptop_ensure_package "font-monaspace"
}
