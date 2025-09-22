#!/usr/bin/env bash

laptop_package_ensure__pack:social() {
  laptop_package_ensure "discord"
  laptop_package_ensure "slack"
  laptop_package_ensure "whatsapp"
  laptop_package_ensure "zoom"
}
