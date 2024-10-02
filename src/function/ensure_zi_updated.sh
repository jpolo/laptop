laptop::ensure_zi_updated() {
  laptop::step_start "- Upgrade zi"
  laptop::step_eval "env zsh --login -i -c \"zi update --all\""
}
