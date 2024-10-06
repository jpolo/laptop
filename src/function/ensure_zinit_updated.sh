laptop::ensure_zinit_updated() {
  laptop::step_start "- Upgrade zi"
  laptop::step_eval "env zsh --login -i -c \"zinit update --all\""
}
