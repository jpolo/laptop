#!/usr/bin/env bash

# macOS defaults settings for developers
laptop_package_ensure__config:macos-global-recommended() {

  # We remove many default completions that adds unwanted characters
  laptop_defaults_ensure NSGlobalDomain AppleShowAllExtensions -bool true
  laptop_defaults_ensure NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
  laptop_defaults_ensure NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
  laptop_defaults_ensure NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
  laptop_defaults_ensure NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  laptop_defaults_ensure NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
  laptop_defaults_ensure NSGlobalDomain NSAutomaticTextCompletionEnabled -bool false
}
