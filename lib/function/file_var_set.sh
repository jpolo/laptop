#!/usr/bin/env bash

.laptop_file_var_set_exported() {
  local script_file="$1"
  local var_name="$2"
  grep -qE "^[[:blank:]]*export[[:blank:]]+${var_name}=" "$script_file"
}

# Set or update a variable in a shell script file.
#
# Usage:
#   laptop_file_var_set "my_shell.sh" "MY_VARIABLE" "MY_VALUE" [--export]
#
# Options:
#   --export  Write the variable as an export assignment (default: false)
#
laptop_file_var_set() {
  local script_file="$1"
  local var_name="$2"
  local new_value="$3"
  local use_export=0
  shift 3

  while [[ $# -gt 0 ]]; do
    case $1 in
    --export)
      use_export=1
      shift
      ;;
    *)
      echo "Unknown option $1" >&2
      return 1
      ;;
    esac
  done

  local var_pattern="^[[:blank:]]*(export[[:blank:]]+)?${var_name}="
  local assignment
  if [ "$use_export" -eq 1 ]; then
    assignment="export ${var_name}=${new_value}"
  else
    assignment="${var_name}=${new_value}"
  fi

  if grep -qE "$var_pattern" "$script_file"; then
    local tmp_file
    tmp_file=$(mktemp)
    grep -vE "$var_pattern" "$script_file" >"$tmp_file"
    echo "$assignment" >>"$tmp_file"
    mv "$tmp_file" "$script_file"
  else
    echo "$assignment" >>"$script_file"
  fi
}
