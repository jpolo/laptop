#!/usr/bin/env bash

laptop_package_ensure__config:macos-screencapture-recommended() {
  ## Screen Capture application
  laptop_defaults_ensure com.apple.screencapture location -string "$HOME/Captures"
  # Save PNG format
  laptop_defaults_ensure com.apple.screencapture type -string "png"
}
