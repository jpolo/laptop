# Filter array keeping only available commands
#
# Example 1 :
#   laptop::filter_command_exists "brew" "npm" "yarn"
#   > "brew" "npm"
#
laptop::filter_command_exists() {
  local filtered_array=()
  for tool in "$@"; do
    case "$tool" in
      zi)
        if env "$SHELL" --login -i -c "command -v $tool" &>/dev/null; then
          filtered_array+=("$tool")
        fi
        ;;
      *)
        if command -v "$tool" &>/dev/null; then
          filtered_array+=("$tool")
        fi
        ;;
    esac
  done
  echo "${filtered_array[@]}"
}
