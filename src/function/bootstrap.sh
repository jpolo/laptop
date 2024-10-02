APT_CORE_PACKAGES=(
  "build-essential"
  "procps"
  "curl"
  "file"
  "git"
  "software-properties-common"
);

laptop::bootstrap_ensure_shell() {
  ensure_shell "$LAPTOP_SHELL"
}

laptop::bootstrap_debian() {
  laptop::bootstrap_ensure_shell
  ensure_apt_updated
  laptop::bootstrap_ensure_apt_core
}

laptop::bootstrap_macos() {
  ensure_package "rosetta2"
  laptop::bootstrap_ensure_xcode
  laptop::bootstrap_ensure_shell
  ensure_brew
  ensure_brew_autodate
}

laptop::bootstrap_ensure_apt_core() {
  laptop::step_start "- Ensure APT core packages"
  laptop::step_exec sudo apt-get install "${APT_CORE_PACKAGES[@]}" -yy;
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
