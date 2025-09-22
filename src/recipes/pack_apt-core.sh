#!/usr/bin/env bash

laptop_package_ensure__pack:apt-core() {
  laptop_apt_ensure_package "build-essential"
  laptop_apt_ensure_package "procps"
  laptop_apt_ensure_package "curl"
  laptop_apt_ensure_package "file"
  laptop_apt_ensure_package "git"
  laptop_apt_ensure_package "software-properties-common"
}
