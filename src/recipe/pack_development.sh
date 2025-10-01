#!/usr/bin/env bash

laptop_package_ensure__pack:development() {
  # laptop_package_ensure "chromedriver" // DEPRECATED
  laptop_package_ensure "docker"
  laptop_package_ensure "iterm2"
  laptop_package_ensure "pgadmin4"
  # laptop_package_ensure "postman" because it's not free anymore (and privacy concerns)
  laptop_package_ensure "virtualbox"
  laptop_package_ensure "visual-studio-code"

  # Fonts for development
  laptop_package_ensure "font-monaspace"
}
