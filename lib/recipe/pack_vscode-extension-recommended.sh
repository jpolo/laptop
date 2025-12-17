#!/usr/bin/env bash

laptop_require "laptop_vscode_ensure_extension"

# macOS defaults settings for developers
laptop_package_ensure__pack:vscode-extension-recommended() {

  # File support formats
  laptop_vscode_ensure_extension "redhat.vscode-yaml"
  laptop_vscode_ensure_extension "tamasfe.even-better-toml"

  # Miscellaneous
  laptop_vscode_ensure_extension "aaron-bond.better-comments"
  laptop_vscode_ensure_extension "eamodio.gitlens"
  laptop_vscode_ensure_extension "EditorConfig.EditorConfig"
  laptop_vscode_ensure_extension "GitHub.vscode-pull-request-github"
  laptop_vscode_ensure_extension "joshbolduc.commitlint"
  laptop_vscode_ensure_extension "ms-vsliveshare.vsliveshare"
  laptop_vscode_ensure_extension "streetsidesoftware.code-spell-checker"

}
