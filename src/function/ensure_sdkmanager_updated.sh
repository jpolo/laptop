laptop::ensure_sdkmanager_updated() {
  laptop::step_start "- Upgrade sdkmanager"
  laptop::step_eval "yes | sdkmanager --licenses && sdkmanager --update"
}
