laptop::ensure_file_template() {
  local template="$1"
  local target="$2"

  laptop::step_start "- Ensure file '$target'"
  laptop::step_eval "\
  mkdir -p $(quote $(dirname $target)) && \
  cp -f $(quote $LAPTOP_PROFILE_CURRENT_DIR/$template) $(quote $target) \
  "
}
