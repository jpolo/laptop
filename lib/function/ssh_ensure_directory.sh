#!/usr/bin/env bash

laptop_require "laptop_directory_ensure"
laptop_require "laptop_file_ensure"

# Ensure SSH directory exists
#
# Usage:
#   laptop_ssh_ensure_directory [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_ssh_ensure_directory() {
  local ssh_dir
  ssh_dir="$HOME/.ssh"
  local ssh_config_file="$ssh_dir/config"
  local resource_status="present"
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -s | --status)
      resource_status="$2"
      shift 2
      ;;
    *) shift ;;
    esac
  done

  laptop_directory_ensure "$ssh_dir" --mode 0700 --status "$resource_status"
  laptop_file_ensure "$ssh_config_file" --mode 0600 --status "$resource_status"
}
