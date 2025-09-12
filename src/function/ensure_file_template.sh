#!/usr/bin/env bash

# Ensure file is created using template
#
# Usage :
#   laptop_ensure_file_template <template> <target>
# Options:
#   --force  Force to overwrite file if present
#
laptop_ensure_file_template() {
  local template="$1"
  local target="$2"
  local force=0
  local positional_args=()

  while [[ $# -gt 0 ]]; do
    case $1 in
      -f|--force)
        force=1
        shift
        ;;
      -*)
        echo "Unknown option $1"
        exit 1
        ;;
      *)
        positional_args+=("$1") # save positional arg
        shift # past argument
        ;;
    esac
  done

  laptop_step_start "- Ensure file '$target'$([ "$force" -eq 1 ] && echo ' (force)') "
  if [ "$force" -eq 0 ] && [ -f "$target" ]; then
    laptop_step_pass
  else
    laptop_step_eval "\
    mkdir -p $(quote "$(dirname "$target")") && \
    cp -f $(quote "$template") $(quote "$target") \
    "
  fi
}
