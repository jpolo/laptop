

laptop::bootstrap_ensure_shell() {
  laptop::ensure_shell "$LAPTOP_SHELL"
}

laptop::bootstrap_debian() {
  laptop::bootstrap_ensure_shell
  laptop::ensure_apt_updated
  laptop::ensure_package "pack:apt-core"
}

laptop::bootstrap_macos() {
  laptop::ensure_package "rosetta2"
  laptop::bootstrap_ensure_xcode
  laptop::bootstrap_ensure_shell
  laptop::ensure_package "brew"
  laptop::ensure_brew_autodate
}

laptop::bootstrap_ensure_xcode() {
  # Install XCode
  laptop::step_start "- Ensure Build tools"
  if ! [ -x "$(command -v gcc)" ]; then
    laptop::step_exec xcode-select --install;
  else
    laptop::step_ok
  fi
}

laptop::bootstrap() {
  if command -v apt-get &> /dev/null; then
    laptop::bootstrap_debian
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    laptop::bootstrap_macos
  else
    return 1
  fi
}
