#!/usr/bin/env bash

laptop_require "laptop_package_ensure"

laptop_package_ensure__pack:development() {
  # laptop_package_ensure "chromedriver" // DEPRECATED
  laptop_package_ensure "docker"
  laptop_package_ensure "iterm2"
  laptop_package_ensure "pgadmin4"
  laptop_package_ensure "postman" --status absent
  laptop_package_ensure "bruno"
  laptop_package_ensure "virtualbox"
  laptop_package_ensure "visual-studio-code"

  # Fonts for development
  laptop_package_ensure "font-monaspace"
}
