#!/usr/bin/env bash

__LAPTOP_CLEANUP_TOOLS=("brew" "docker" "gem" "npm" "pod" "zinit")

__program_cleanup_detect() {
  local filtered_commands=$(filter_command_exists "${__LAPTOP_CLEANUP_TOOLS[@]}")
  echo "The following tools were found and will be cleaned :"
  echo ""
  # Iterate over the tools and check for their existence
  for tool in ${filtered_commands}; do
    echo "  ✓ $tool"
  done
  echo ""
}

__program_cleanup_run() {
  local filtered_commands=$(filter_command_exists "${__LAPTOP_CLEANUP_TOOLS[@]}")

  for tool in $filtered_commands; do
    case "$tool" in
      brew)
        _laptop_step_start "- Cleanup brew"
        _laptop_step_eval "brew cleanup --prune=all"
        ;;
      docker)
        _laptop_step_start "- Prune docker images"
        _laptop_step_eval "docker system prune -af"
        ;;
      gem)
        _laptop_step_start "- Cleanup gem"
        _laptop_step_eval "gem cleanup"
        ;;
      npm)
        _laptop_step_start "- Clean npm cache"
        _laptop_step_eval "npm cache clean --force"
        ;;
      pod)
        _laptop_step_start "- Clean pod cache"
        _laptop_step_eval "pod cache clean --all"
        ;;
      zinit)
        _laptop_step_start "- Cleanup zinit"
        _laptop_step_eval "env zsh --login -i -c \"zinit delete --clean --quiet --yes\""
        ;;
      *)
        echo "Unknown tool: $tool"
        ;;
    esac
  done
}

__program_cleanup() {
  _laptop-logo
  __program_cleanup_detect
  if confirm "Continue? (Y/n)"; then
    __program_cleanup_run

    einfo "🎉 Cleanup successful"
  else
    eerror "🛑 Cleanup aborted"
    exit 1
  fi
}
