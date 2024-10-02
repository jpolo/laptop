laptop::ensure_brew_tap() {
  local tap="$1"
  laptop::step_start "- Ensure brew tap '$tap'"
  laptop::step_eval "brew tap $tap"
}
