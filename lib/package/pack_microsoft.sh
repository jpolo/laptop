#!/usr/bin/env bash

laptop_require "laptop_package_ensure_default"

laptop_package_ensure__pack:microsoft() {
  laptop_package_ensure_default "microsoft-teams"
}
