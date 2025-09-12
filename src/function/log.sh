#!/usr/bin/env bash

laptop_error() {
  echo -e "${COLOR_ERROR}Error: ${NORMAL}$*" >&2
}

laptop_warn() {
  echo -e "${COLOR_WARNING}Warning: ${NORMAL}$*"
}

laptop_info() {
  echo -e "${COLOR_INFO}Info: ${NORMAL}$*"
}
