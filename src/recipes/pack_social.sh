#!/usr/bin/env bash

laptop::ensure_package__pack:social() {
  laptop::ensure_package "discord"
  laptop::ensure_package "slack"
}
