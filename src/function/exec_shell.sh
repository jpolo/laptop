laptop::exec_shell() {
  local shell=$1
  local script=$2
  env "$shell" --login -i "$script"
}
