#
# Usage:
#   laptop::command_exists <command>
#
laptop::command_exists() {
  case "$tool" in
    zinit)
      if env "$SHELL" --login -i -c "command -v $tool" &>/dev/null; then
        return 0
      fi
      ;;
    *)
      if [ -x "$(command -v "$1")" ]; then
        return 0
      fi
      ;;
  esac

  return 1
}
