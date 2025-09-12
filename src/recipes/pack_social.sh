#!/usr/bin/env bash

laptop_ensure_package__pack:social() {
  laptop_ensure_package "discord"
  laptop_ensure_package "slack"
  laptop_ensure_package "whatsapp"
  laptop_ensure_package "zoom"
}
