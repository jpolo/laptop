#!/usr/bin/env bash

laptop_ensure_package__pack:productivity() {
  laptop_ensure_package "chatgpt"
  laptop_ensure_package "ollama"
  laptop_ensure_package "drawio"
  laptop_ensure_package "notion"
  # laptop_ensure_package "rectangle"
  if [[ ${LAPTOP_PROFILE_PRIVACY:-strict} = strict ]];then
    laptop_ensure_package "vivaldi"
  else
    laptop_ensure_package "google-chrome"
    laptop_ensure_package "google-drive"
  fi
}
