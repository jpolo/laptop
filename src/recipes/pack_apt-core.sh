
laptop::ensure_package__pack:apt-core() {
  laptop::ensure_apt_package "build-essential"
  laptop::ensure_apt_package "procps"
  laptop::ensure_apt_package "curl"
  laptop::ensure_apt_package "file"
  laptop::ensure_apt_package "git"
  laptop::ensure_apt_package "software-properties-common"
}
