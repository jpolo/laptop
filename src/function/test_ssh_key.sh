#!/usr/bin/env bash

laptop::ssh_key_test() {
  local host="$1"
  ssh -T "$host" >/dev/null 2>&1
  if [ $? -ge 2 ]; then
    return 1
  else
    return 0
  fi
}
