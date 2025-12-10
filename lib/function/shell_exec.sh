#!/usr/bin/env bash

# Execute a script in a shell with the laptop environment
# It will source the "$LAPTOP_HOME/lib/init.sh" that will set up variables and functions
#
# Usage:
#   laptop_shell_exec <shell> <script>
#
# Example:
#   laptop_shell_exec "zsh" "steps/0-configure-all.zsh"
laptop_shell_exec() {
  local shell="$1"
  local script="$2"
  env "$shell" --login -i -c "source \"$LAPTOP_HOME/lib/init.sh\" && source \"$script\""
}
