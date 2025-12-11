#!/usr/bin/env bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  _XDG_DATA_HOME_DEFAULT="$HOME/Library"
  _XDG_CONFIG_HOME_DEFAULT="$HOME/Library/Preferences"
  _XDG_CACHE_HOME_DEFAULT="$HOME/Library/Caches"
  _XDG_STATE_HOME_DEFAULT="$HOME/Library/Application Support"
else
  _XDG_DATA_HOME_DEFAULT="$HOME/.local/share"
  _XDG_CONFIG_HOME_DEFAULT="$HOME/.config"
  _XDG_CACHE_HOME_DEFAULT="$HOME/.cache"
  _XDG_STATE_HOME_DEFAULT="$HOME/.local/state"
fi

# Get the XDG directory path for a specific type
#
# Usage: laptop_xdg_dir <type>
#
# type: data, config, cache, runtime
laptop_xdg_dir() {
  case "$1" in
  data)
    echo "${XDG_DATA_HOME:-$_XDG_DATA_HOME_DEFAULT}"
    ;;
  config)
    echo "${XDG_CONFIG_HOME:-$_XDG_CONFIG_HOME_DEFAULT}"
    ;;
  cache)
    echo "${XDG_CACHE_HOME:-$_XDG_CACHE_HOME_DEFAULT}"
    ;;
  state)
    echo "${XDG_STATE_HOME:-$_XDG_STATE_HOME_DEFAULT}"
    ;;
  *)
    echo "Usage: laptop_xdg_dir {data|config|cache|state}" >&2
    return 1
    ;;
  esac
}
