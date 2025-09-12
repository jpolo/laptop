#!/usr/bin/env bash

laptop_function_exists() {
  declare -f -F "$1" >/dev/null
  return $?
}
