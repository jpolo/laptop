laptop::ensure_git_config() {
  local name="$1"
  local value="$2"

  laptop::step_start "- Ensure git config '$name'='${value:-"<custom>"}'"
  if [ -z "$(git config --global "$name")" ]; then
    if [ -z "${value}" ]; then
      echo "Git: Please enter value for '$name'"
      read value
    fi

    laptop::step_exec git config --global "$name" "$value"
  else
    laptop::step_ok
  fi
}
