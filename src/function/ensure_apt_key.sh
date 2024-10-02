laptop::ensure_apt_key() {
  local repo_key="$1"
  laptop::step_start "- Ensure apt key '$repo_url'"
  laptop::step_eval "! wget -qO - "$repo_key" | sudo apt-key add -"
}
