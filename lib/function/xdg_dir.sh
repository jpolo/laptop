#!/bin/bash

# Get the XDG directory path for a specific type
#
# Usage: laptop_xdg_dir <type>
#
# type: data, config, cache, runtime
laptop_xdg_dir() {
  case "$1" in
  data)
    echo "${XDG_DATA_HOME:-$HOME/.local/share}"
    ;;
  config)
    echo "${XDG_CONFIG_HOME:-$HOME/.config}"
    ;;
  cache)
    echo "${XDG_CACHE_HOME:-$HOME/.cache}"
    ;;
  runtime)
    echo "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
    ;;
  *)
    echo "Usage: laptop_xdg_dir {data|config|cache|runtime}" >&2
    return 1
    ;;
  esac
}
