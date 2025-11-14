#!/usr/bin/env bash

# @see https://github.com/heroku/buildpack-stdlib/blob/master/stdlib.sh
STD_STEP_HEADER="----->"

# throw an error with an error message
error_exit() {
    echo "${1:-"Unknown Error"}" 1>&2
    exit 1
}

# Buildpack Steps.
puts_step() {
  if [[ "$*" == "-" ]]; then
    read -r output
  else
    output=$*
  fi
  printf "\\e[1m\\e[36m$STD_STEP_HEADER $output\\e[0m\n"
  unset output
}

# Buildpack Error.
puts_error() {
  if [[ "$*" == "-" ]]; then
    read -r output
  else
    output=$*
  fi
  printf "\\e[1m\\e[31m=!= $output\\e[0m\n"
}

# Buildpack Warning.
puts_warn() {
  if [[ "$*" == "-" ]]; then
    read -r output
  else
    output=$*
  fi
  printf "\\e[1m\\e[33m=!= $output\\e[0m\n"
}
