#!/usr/bin/env bash

laptop_ensure_package__pack:apt-core() {
  laptop_ensure_apt_package "build-essential"
  laptop_ensure_apt_package "procps"
  laptop_ensure_apt_package "curl"
  laptop_ensure_apt_package "file"
  laptop_ensure_apt_package "git"
  laptop_ensure_apt_package "software-properties-common"
}
