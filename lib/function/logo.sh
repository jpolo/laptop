#!/usr/bin/env bash

laptop_logo() {
  local color_logo
  color_logo="$(laptop_ansi bold)$(laptop_ansi blue)"

  echo -e "$color_logo"
  cat <<-"EOF"
╻  ┏━┓┏━┓╺┳╸┏━┓┏━┓
┃  ┣━┫┣━┛ ┃ ┃ ┃┣━┛
┗━╸╹ ╹╹   ╹ ┗━┛╹
───────────────────
EOF
  echo -e "$NORMAL"
}
