#!/usr/bin/env bash

laptop_shell_exec() {
  local shell=$1
  local script=$2
  env "$shell" --login -i "$script"
}
