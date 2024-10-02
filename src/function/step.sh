
laptop::step_start() {
  echo -n -e "${@}"
  return 0
}

laptop::step_ok() {
  # echo -n -e "${@}"
  echo -e "${SET_COL}${BRACKET}[${SUCCESS}  OK  ${BRACKET}]${NORMAL}"
  return 0
}

laptop::step_fail() {
  # echo -n -e "${@}"
  echo -e "${SET_COL}${BRACKET}[${FAILURE} FAIL ${BRACKET}]${NORMAL}"
  return 0
}

laptop::step_pass() {
  #echo -n -e "${@}"
  echo -e "${SET_COL}${BRACKET}[${NORMAL} PASS ${BRACKET}]${NORMAL}"
  return 0
}

laptop::step_complete() {
  local command=$1
  local exit_code=$2
  local output=$3

  if [ "$exit_code" = "0" ]; then
    laptop::step_ok
  else
    laptop::step_fail
    eerror "Command failed \
      \\n|  > $command \
      \\n|  $output"
  fi
}

laptop::step_exec() {
  laptop::step_eval "$*"
}

laptop::step_eval() {
  local output;
  local command="$1"
  output=$(eval "$command" 2>&1)
  local exit_code=$?

 laptop::step_complete "$command" "$exit_code" "$output"
}


