laptop::command_exists() {
  if [ -x "$(command -v "$1")" ]; then
    return 0
  else
    return 1
  fi
}
