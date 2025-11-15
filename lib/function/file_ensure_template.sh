#!/usr/bin/env bash

# Ensure file is created using template
#
# Usage :
#   laptop_file_ensure_template <template> <target>
# Options:
#   --force  Force to overwrite file if present
#
laptop_file_ensure_template() {
  local template="$1"
  local target="$2"
  local force=0
  local positional_args=()

  while [[ $# -gt 0 ]]; do
    case $1 in
    -f | --force)
      force=1
      shift
      ;;
    -*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      positional_args+=("$1") # save positional arg
      shift                   # past argument
      ;;
    esac
  done
  local current_resource_status="absent"
  if [ -f "$target" ]; then
    # test if $template file is identical to $target file
    if cmp -s "$template" "$target"; then
      current_resource_status="present"
    fi
  else
    current_resource_status="absent"
  fi

  laptop_step_start_status "present" "$current_resource_status" "Template '$(laptop_path_print "$target")'$([ "$force" -eq 1 ] && echo ' (force)') "
  if [ "$force" -eq 0 ] && [ -f "$target" ]; then
    laptop_step_pass
  else
    laptop_step_eval "\
    mkdir -p $(quote "$(dirname "$target")") && \
    cp -f $(quote "$template") $(quote "$target") \
    "
  fi
}
