#!/usr/bin/env bash

laptop_require "laptop_vscode_ensure_extension_list"

laptop_package_ensure__profile:vscode-extensions() {
  laptop_vscode_ensure_extension_list "$(laptop_profile_dir)/codefile"
}
