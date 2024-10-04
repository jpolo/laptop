laptop::ensure_ssh_key() {
  local algorithm=${1:-"ed25519"}
  local ssh_key="$HOME/.ssh/id_$algorithm"
  local email=$(git config --global user.email)

  laptop::step_start "- Ensure SSH key '$ssh_key'"
  if [ -z "$email" ];then
    laptop::step_fail
    laptop::error "git config user.email is empty";
  elif ! [ -f "$ssh_key" ]; then
    laptop::step_exec ssh-keygen -t $algorithm -C "$email" -N '' -o -f $ssh_key
  else
    laptop::step_ok
  fi
}
