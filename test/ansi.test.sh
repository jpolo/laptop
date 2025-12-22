#!/usr/bin/env bash

# Test laptop_ansi

assert_raises "laptop_ansi reset" 0
assert "LAPTOP_COLOR=true laptop_ansi reset" "\033[0m"
assert "LAPTOP_COLOR=false laptop_ansi reset" ""
assert_raises "laptop_ansi bold" 0
assert "LAPTOP_COLOR=true laptop_ansi bold" "\033[1m"
assert "LAPTOP_COLOR=false laptop_ansi bold" ""
assert_raises "laptop_ansi dim" 0
assert "LAPTOP_COLOR=true laptop_ansi dim" "\033[2m"
assert "LAPTOP_COLOR=false laptop_ansi dim" ""
assert_raises "laptop_ansi underline" 0
assert "LAPTOP_COLOR=true laptop_ansi underline" "\033[4m"
assert "LAPTOP_COLOR=false laptop_ansi underline" ""
assert_raises "laptop_ansi reverse" 0
assert "LAPTOP_COLOR=true laptop_ansi reverse" "\033[7m"
assert "LAPTOP_COLOR=false laptop_ansi reverse" ""
assert_raises "laptop_ansi clear" 0
assert "LAPTOP_COLOR=true laptop_ansi clear" "\033[2J\033[H"
assert "LAPTOP_COLOR=false laptop_ansi clear" ""
assert_raises "laptop_ansi black" 0
assert "LAPTOP_COLOR=true laptop_ansi black" "\033[30m"
assert "LAPTOP_COLOR=false laptop_ansi black" ""
assert_raises "laptop_ansi red" 0
assert "LAPTOP_COLOR=true laptop_ansi red" "\033[31m"
assert "LAPTOP_COLOR=false laptop_ansi red" ""
assert_raises "laptop_ansi green" 0
assert "LAPTOP_COLOR=true laptop_ansi green" "\033[32m"
assert "LAPTOP_COLOR=false laptop_ansi green" ""
assert_raises "laptop_ansi yellow" 0
assert "LAPTOP_COLOR=true laptop_ansi yellow" "\033[33m"
assert "LAPTOP_COLOR=false laptop_ansi yellow" ""
assert_raises "laptop_ansi blue" 0
assert "LAPTOP_COLOR=true laptop_ansi blue" "\033[34m"
assert "LAPTOP_COLOR=false laptop_ansi blue" ""
assert_raises "laptop_ansi magenta" 0
assert "LAPTOP_COLOR=true laptop_ansi magenta" "\033[35m"
assert "LAPTOP_COLOR=false laptop_ansi magenta" ""
assert_raises "laptop_ansi cyan" 0
assert "LAPTOP_COLOR=true laptop_ansi cyan" "\033[36m"
assert "LAPTOP_COLOR=false laptop_ansi cyan" ""
assert_raises "laptop_ansi white" 0
assert "LAPTOP_COLOR=true laptop_ansi white" "\033[37m"
assert "LAPTOP_COLOR=false laptop_ansi white" ""
assert_raises "laptop_ansi bg_black" 0
assert "LAPTOP_COLOR=true laptop_ansi bg_black" "\033[40m"
assert "LAPTOP_COLOR=false laptop_ansi bg_black" ""
assert_raises "laptop_ansi bg_red" 0
assert "LAPTOP_COLOR=true laptop_ansi bg_red" "\033[41m"
assert "LAPTOP_COLOR=false laptop_ansi bg_red" ""
assert_raises "laptop_ansi bg_green" 0
assert "LAPTOP_COLOR=true laptop_ansi bg_green" "\033[42m"
assert "LAPTOP_COLOR=false laptop_ansi bg_green" ""
assert_raises "laptop_ansi bg_yellow" 0
assert "LAPTOP_COLOR=true laptop_ansi bg_yellow" "\033[43m"
assert "LAPTOP_COLOR=false laptop_ansi bg_yellow" ""
assert_raises "laptop_ansi bg_blue" 0
assert "LAPTOP_COLOR=true laptop_ansi bg_blue" "\033[44m"
assert "LAPTOP_COLOR=false laptop_ansi bg_blue" ""
assert_raises "laptop_ansi bg_magenta" 0
assert "LAPTOP_COLOR=true laptop_ansi bg_magenta" "\033[45m"
assert "LAPTOP_COLOR=false laptop_ansi bg_magenta" ""
assert_raises "laptop_ansi bg_cyan" 0
assert "LAPTOP_COLOR=true laptop_ansi bg_cyan" "\033[46m"
assert "LAPTOP_COLOR=false laptop_ansi bg_cyan" ""
assert_raises "laptop_ansi bg_white" 0
assert "LAPTOP_COLOR=true laptop_ansi bg_white" "\033[47m"
assert "LAPTOP_COLOR=false laptop_ansi bg_white" ""
