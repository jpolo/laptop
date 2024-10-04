laptop::bootstrap_debian() {
  laptop::ensure_shell "$LAPTOP_SHELL"
  laptop::ensure_apt_updated
  laptop::ensure_package "pack:apt-core"
}

laptop::bootstrap_macos() {
  laptop::ensure_package "rosetta2"
  laptop::ensure_package "xcode-command-line-tools"
  laptop::ensure_shell "$LAPTOP_SHELL"
  laptop::ensure_package "brew"
  laptop::ensure_brew_autodate
}

laptop::bootstrap() {
  if command -v apt-get &> /dev/null; then
    laptop::bootstrap_debian
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    laptop::bootstrap_macos
  else
    laptop::die "Unsupported OS. Only debian based and macos is supported."
  fi
}
