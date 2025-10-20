#!/usr/bin/env bash

laptop_package_ensure__pack:productivity() {
  laptop_package_ensure "chatgpt"
  laptop_package_ensure "ollama"
  laptop_package_ensure "drawio"
  laptop_package_ensure "notion"
  laptop_package_ensure "hiddenbar"
  # laptop_package_ensure "rectangle"
  if [[ ${LAPTOP_PROFILE_PRIVACY:-strict} = strict ]];then
    laptop_package_ensure "vivaldi"
  else
    laptop_package_ensure "google-chrome"
    laptop_package_ensure "google-drive"
  fi
}
