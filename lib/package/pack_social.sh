#!/usr/bin/env bash

laptop_require "laptop_package_ensure"

laptop_package_ensure__pack:social() {
  laptop_package_ensure "discord"
  laptop_package_ensure "slack"
  # laptop_package_ensure "whatsapp" Not often used for work
  # laptop_package_ensure "zoom" Not often used for work
}
