#!/usr/bin/env bash

laptop::error() {
  echo -e "${COLOR_ERROR}Error: ${NORMAL}$*" >&2
}

laptop::warn() {
  echo -e "${COLOR_WARNING}Warning: ${NORMAL}$*"
}

laptop::info() {
  echo -e "${COLOR_INFO}Info: ${NORMAL}$*"
}
