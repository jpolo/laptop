#!/usr/bin/env bash

laptop::ensure_package__pack:development() {
  laptop::ensure_package "chromedriver"
  laptop::ensure_package "docker"
  laptop::ensure_package "iterm2"
  laptop::ensure_package "mongodb-community"
  laptop::ensure_package "mongodb-database-tools"
  laptop::ensure_package "mysql"
  laptop::ensure_package "pgadmin4"
  laptop::ensure_package "postman"
  # FIXME: Does not work on Apple Silicon M1, M2, etc
  # Error: Cask virtualbox depends on hardware architecture being one of [{:type=>:intel, :bits=>64}], but you are running {:type=>:arm, :bits=>64}.
  # laptop::ensure_package "virtualbox"
  laptop::ensure_package "visual-studio-code"

  # Fonts for development
  laptop::ensure_package "font-monaspace"
}
