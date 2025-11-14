#!/usr/bin/env bash

# macOS defaults settings for developers
laptop_package_ensure__config:vscode-recommended() {

  # Important dangerous settings to disable
  # They must be handled with editorconfig on a per extension basis
  laptop_vscode_ensure_setting '["files.insertFinalNewline"]' --status absent
  laptop_vscode_ensure_setting '["files.trimFinalNewlines"]' --status absent
  laptop_vscode_ensure_setting '["files.trimTrailingWhitespace"]' --status absent
  laptop_vscode_ensure_setting '["editor.trimAutoWhitespace"]' --status absent
  laptop_vscode_ensure_setting '["editor.tabSize"]' --status absent

  # Remove, so it is default value
  laptop_vscode_ensure_setting '["window.commandCenter"]' --status absent

  # Display enhancements
  laptop_vscode_ensure_setting '["workbench.fontAliasing"]' '"auto"'

  laptop_vscode_ensure_setting '["editor.bracketPairColorization.enabled"]' 'true'
  laptop_vscode_ensure_setting '["git.confirmSync"]' 'false'
  laptop_vscode_ensure_setting '["git.autofetch"]' 'true'

  # Disable gitlens pro features annoying messages
  laptop_vscode_ensure_setting '["gitlens.plusFeatures.enabled"]' 'false'
}
