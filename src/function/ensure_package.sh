laptop::ensure_package() {
  local executable="$1"
  local package="${2:-$executable}"

  # Attempt to launch a function named laptop::ensure_package__$package" if exists
  local recipe_function="laptop::ensure_package__$package"

  if laptop::function_exists "$recipe_function";then
    $recipe_function
    return 0
  else
    laptop::ensure_package_default "$executable" "$package"
  fi
}

laptop::ensure_package_default() {
  local executable="$1"
  local package=${2:-$executable}

  # Install using package manager
  if [ $LAPTOP_PACKAGE_MANAGER = "brew" ];then
    laptop::ensure_brew_package "$executable" "$package"
  elif [ $LAPTOP_PACKAGE_MANAGER = "apt-get" ];then
    laptop::ensure_apt_package "$executable" "$package"
  else
    laptop::step_fail
  fi
}
