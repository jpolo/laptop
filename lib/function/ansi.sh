#!/usr/bin/env bash

_LAPTOP_COLOR_RESET="\033[0m"
_LAPTOP_COLOR_BOLD="\033[1m"
_LAPTOP_COLOR_DIM="\033[2m"
_LAPTOP_COLOR_UNDERLINE="\033[4m"
_LAPTOP_COLOR_REVERSE="\033[7m"
_LAPTOP_COLOR_CLEAR="\033[2J\033[H"
_LAPTOP_COLOR_BLACK="\033[30m"
_LAPTOP_COLOR_RED="\033[31m"
_LAPTOP_COLOR_GREEN="\033[32m"
_LAPTOP_COLOR_YELLOW="\033[33m"
_LAPTOP_COLOR_BLUE="\033[34m"
_LAPTOP_COLOR_MAGENTA="\033[35m"
_LAPTOP_COLOR_CYAN="\033[36m"
_LAPTOP_COLOR_WHITE="\033[37m"
_LAPTOP_COLOR_BG_BLACK="\033[40m"
_LAPTOP_COLOR_BG_RED="\033[41m"
_LAPTOP_COLOR_BG_GREEN="\033[42m"
_LAPTOP_COLOR_BG_YELLOW="\033[43m"
_LAPTOP_COLOR_BG_BLUE="\033[44m"
_LAPTOP_COLOR_BG_MAGENTA="\033[45m"
_LAPTOP_COLOR_BG_CYAN="\033[46m"
_LAPTOP_COLOR_BG_WHITE="\033[47m"

# Remove ANSI escape codes from a string
#
# Usage:
#   laptop_ansi <code>
#
laptop_ansi() {
  local code="$1"
  if [ "$LAPTOP_COLOR" = "true" ]; then
    case "$code" in
      "reset")
        echo -e "${_LAPTOP_COLOR_RESET}"
        ;;
      "bold")
        echo -e "${_LAPTOP_COLOR_BOLD}"
        ;;
      "dim")
        echo -e "${_LAPTOP_COLOR_DIM}"
        ;;
      "underline")
        echo -e "${_LAPTOP_COLOR_UNDERLINE}"
        ;;
      "reverse")
        echo -e "${_LAPTOP_COLOR_REVERSE}"
        ;;
      "clear")
        echo -e "${_LAPTOP_COLOR_CLEAR}"
        ;;
      "black")
        echo -e "${_LAPTOP_COLOR_BLACK}"
        ;;
      "red")
        echo -e "${_LAPTOP_COLOR_RED}"
        ;;
      "green")
        echo -e "${_LAPTOP_COLOR_GREEN}"
        ;;
      "yellow")
        echo -e "${_LAPTOP_COLOR_YELLOW}"
        ;;
      "blue")
        echo -e "${_LAPTOP_COLOR_BLUE}"
        ;;
      "magenta")
        echo -e "${_LAPTOP_COLOR_MAGENTA}"
        ;;
      "cyan")
        echo -e "${_LAPTOP_COLOR_CYAN}"
        ;;
      "white")
        echo -e "${_LAPTOP_COLOR_WHITE}"
        ;;
      "bg_black")
        echo -e "${_LAPTOP_COLOR_BG_BLACK}"
        ;;
      "bg_red")
        echo -e "${_LAPTOP_COLOR_BG_RED}"
        ;;
      "bg_green")
        echo -e "${_LAPTOP_COLOR_BG_GREEN}"
        ;;
      "bg_yellow")
        echo -e "${_LAPTOP_COLOR_BG_YELLOW}"
        ;;
      "bg_blue")
        echo -e "${_LAPTOP_COLOR_BG_BLUE}"
        ;;
      "bg_magenta")
        echo -e "${_LAPTOP_COLOR_BG_MAGENTA}"
        ;;
      "bg_cyan")
        echo -e "${_LAPTOP_COLOR_BG_CYAN}"
        ;;
      "bg_white")
        echo -e "${_LAPTOP_COLOR_BG_WHITE}"
        ;;
      *)
        laptop_die "Invalid ANSI code: $code"
    esac
  fi
}
