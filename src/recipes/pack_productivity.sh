#!/usr/bin/env bash

laptop::ensure_package__pack:productivity() {
  laptop::ensure_package "chatgpt"
  laptop::ensure_package "drawio"
  laptop::ensure_package "notion"
  # laptop::ensure_package "rectangle"

  laptop::ensure_package "google-chrome"
  laptop::ensure_package "google-drive"
}
