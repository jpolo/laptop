APT_CORE_PACKAGES=(
  "build-essential"
  "procps"
  "curl"
  "file"
  "git"
  "software-properties-common"
);

laptop::bootstrap_laptop::ensure_shell() {
  laptop::ensure_shell "$LAPTOP_SHELL"
}

laptop::bootstrap_debian() {
  laptop::bootstrap_laptop::ensure_shell
  laptop::ensure_apt_updated
  laptop::bootstrap_laptop::ensure_apt_core
}

laptop::bootstrap_macos() {
  laptop::ensure_package "rosetta2"
  laptop::bootstrap_laptop::ensure_xcode
  laptop::bootstrap_laptop::ensure_shell
  laptop::ensure_brew
  laptop::ensure_brew_autodate
}

laptop::bootstrap_laptop::ensure_apt_core() {
  laptop::step_start "- Ensure APT core packages"
  laptop::step_exec sudo apt-get install "${APT_CORE_PACKAGES[@]}" -yy;
}

laptop::bootstrap_laptop::ensure_xcode() {
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