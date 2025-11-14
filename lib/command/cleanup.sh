#!/usr/bin/env bash

__LAPTOP_CLEANUP_TOOLS=("brew" "docker" "gem" "npm" "pod" "xcrun" "zinit")

laptop_command__cleanup_detect() {
  local filtered_commands
  filtered_commands=$(laptop_filter_command_exists "${__LAPTOP_CLEANUP_TOOLS[@]}")
  echo "The following tools were found and will be cleaned :"
  echo ""
  # Iterate over the tools and check for their existence
  for tool in ${filtered_commands}; do
    echo "  ✓ $tool"
  done
  echo ""
}

laptop_command__cleanup_run() {
  local filtered_commands
  filtered_commands=$(laptop_filter_command_exists "${__LAPTOP_CLEANUP_TOOLS[@]}")
  local initial_available_space
  initial_available_space=$(laptop_disk_available_space)

  # Cleanup by command
  for tool in $filtered_commands; do
    case "$tool" in
    brew)
      laptop_step_start "- Cleanup brew"
      laptop_step_eval "brew cleanup --prune=all"
      ;;
    docker)
      laptop_step_start "- Prune docker images"
      laptop_step_eval "docker image prune -a --force"
      ;;
    gem)
      laptop_step_start "- Cleanup gem"
      laptop_step_eval "gem cleanup"
      ;;
    npm)
      laptop_step_start "- Clean npm cache"
      laptop_step_eval "npm cache clean --force"
      ;;
    pod)
      laptop_step_start "- Clean pod cache"
      laptop_step_eval "pod cache clean --all"
      ;;
    xcrun)
      laptop_step_start "- Clean XCode simulators"
      laptop_step_eval "xcrun simctl delete unavailable"
      ;;
    zinit)
      laptop_step_start "- Cleanup zinit"
      laptop_step_eval "env zsh --login -i -c \"zinit cclear; zinit delete --clean --quiet --yes\""
      ;;
    *)
      echo "Unknown tool: $tool"
      ;;
    esac
  done

  # Cleanup by directory
  laptop_directory_ensure_empty "$HOME/Library/Developer/Xcode/DerivedData"
  laptop_directory_ensure_empty "$HOME/.gradle/caches"

  new_available_space=$(laptop_disk_available_space)
  laptop_command__cleanup_result $((new_available_space - initial_available_space))
}

laptop_command__cleanup_result() {
  b=${1:-0}
  d=''
  s=1
  S=(Bytes {K,M,G,T,E,P,Y,Z}iB)
  while ((b > 1024)); do
    d="$(printf ".%02d" $((b % 1024 * 100 / 1024)))"
    b=$((b / 1024))
    ((s++))
  done
  laptop_info "$b$d ${S[$s]} of space was cleaned up"
}

laptop_command__cleanup() {
  laptop_handler_call "logo"
  laptop_self_check_version

  laptop_command__cleanup_detect
  if laptop_confirm "Continue? (Y/n)"; then
    laptop_command__cleanup_run

    laptop_info "🎉 Cleanup successful"
  else
    laptop_die "🛑 Cleanup aborted"
  fi
}
