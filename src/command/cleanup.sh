#!/usr/bin/env bash

__LAPTOP_CLEANUP_TOOLS=("brew" "docker" "gem" "npm" "pod" "xcrun" "zi")

laptop::command__cleanup_detect() {
  local filtered_commands=$(laptop::filter_command_exists "${__LAPTOP_CLEANUP_TOOLS[@]}")
  echo "The following tools were found and will be cleaned :"
  echo ""
  # Iterate over the tools and check for their existence
  for tool in ${filtered_commands}; do
    echo "  ✓ $tool"
  done
  echo ""
}

laptop::command__cleanup_run() {
  local filtered_commands=$(laptop::filter_command_exists "${__LAPTOP_CLEANUP_TOOLS[@]}")
  local initial_available_space=$(laptop::disk_available_space)

  # Cleanup by command
  for tool in $filtered_commands; do
    case "$tool" in
      brew)
        laptop::step_start "- Cleanup brew"
        laptop::step_eval "brew cleanup --prune=all"
        ;;
      docker)
        laptop::step_start "- Prune docker images"
        laptop::step_eval "docker image prune -a --force"
        ;;
      gem)
        laptop::step_start "- Cleanup gem"
        laptop::step_eval "gem cleanup"
        ;;
      npm)
        laptop::step_start "- Clean npm cache"
        laptop::step_eval "npm cache clean --force"
        ;;
      pod)
        laptop::step_start "- Clean pod cache"
        laptop::step_eval "pod cache clean --all"
        ;;
      xcrun)
        laptop::step_start "- Clean XCode simulators"
        laptop::step_eval "xcrun simctl delete unavailable"
        ;;
      zi)
        laptop::step_start "- Cleanup zi"
        laptop::step_eval "env zsh --login -i -c \"zinit delete --clean --quiet --yes; zinit cclear\""
        ;;
      *)
        echo "Unknown tool: $tool"
        ;;
    esac
  done

  # Cleanup by directory
  laptop::ensure_directory_empty "$HOME/Library/Developer/Xcode/DerivedData"
  laptop::ensure_directory_empty "$HOME/.gradle/caches"

  new_available_space=$(laptop::disk_available_space)
  laptop::command__cleanup_result $((new_available_space - initial_available_space))
}

laptop::command__cleanup_result() {
	b=${1:-0}
	d=''
	s=1
	S=(Bytes {K,M,G,T,E,P,Y,Z}iB)
	while ((b > 1024)); do
		d="$(printf ".%02d" $((b % 1024 * 100 / 1024)))"
		b=$((b / 1024))
		((s++))
	done
	laptop::info "$b$d ${S[$s]} of space was cleaned up"
}

laptop::command__cleanup() {
  laptop::logo
  laptop::command__cleanup_detect
  if laptop::confirm "Continue? (Y/n)"; then
    laptop::command__cleanup_run

    laptop::info "🎉 Cleanup successful"
  else
    laptop::error "🛑 Cleanup aborted"
    exit 1
  fi
}
