#!/usr/bin/env bash

laptop_require "laptop_ssh_ensure_directory"
laptop_require "laptop_ssh_ensure_setting"

laptop_package_ensure__config:ssh-recommended() {
  laptop_ssh_ensure_directory
  laptop_ssh_ensure_setting "Host *" "AddKeysToAgent" "yes"
  laptop_ssh_ensure_setting "Host *" "UseKeychain" "yes"
}
