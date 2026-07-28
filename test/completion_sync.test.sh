#!/usr/bin/env bash

# Ensure shell completions stay in sync with lib/command and config subcommand surface.

_completion_sync__sorted_words() {
  tr ' ' '\n' | sort | tr '\n' ' ' | sed 's/ $//'
}

_completion_sync__expected_subcommands() {
  local command_file command_name

  for command_file in "$LAPTOP_HOME/lib/command/"*.sh; do
    command_name=$(basename "$command_file" .sh)
    printf '%s\n' "$command_name"
  done
  printf '%s\n' help
}

_completion_sync__expected_config_types() {
  sed -n '/case "$config_type" in/,/esac/p' "$LAPTOP_HOME/lib/command/config.sh" \
    | grep -E '^[[:space:]]+"[a-z]+"\)' \
    | sed 's/^[[:space:]]*"//;s/").*$//'
}

_completion_sync__expected_config_actions() {
  sed -n '/case "$action" in/,/esac/p' "$LAPTOP_HOME/lib/command/config.sh" \
    | grep -E '^[[:space:]]+"[a-z]+"\)' \
    | sed 's/^[[:space:]]*"//;s/").*$//'
}

_completion_sync__completion_array() {
  local completion_file="$1"
  local array_name="$2"

  sed -n "s/.*${array_name}=(\\([^)]*\\)).*/\\1/p" "$completion_file" | head -1
}

_completion_sync__assert_lists_equal() {
  local label="$1"
  local expected="$2"
  local actual="$3"
  local expected_sorted actual_sorted

  expected_sorted=$(printf '%s\n' $expected | _completion_sync__sorted_words)
  actual_sorted=$(printf '%s\n' $actual | _completion_sync__sorted_words)

  if [[ "$expected_sorted" != "$actual_sorted" ]]; then
    echo "$label: expected [$expected_sorted], got [$actual_sorted]" >&2
    return 1
  fi
}

ZSH_COMPLETION_FILE="$LAPTOP_HOME/share/zsh/site-functions/_laptop"
BASH_COMPLETION_FILE="$LAPTOP_HOME/share/bash-completion/completions/laptop"

expected_subcommands=$(_completion_sync__expected_subcommands | _completion_sync__sorted_words)
expected_config_types=$(_completion_sync__expected_config_types | _completion_sync__sorted_words)
expected_config_actions=$(_completion_sync__expected_config_actions | _completion_sync__sorted_words)

zsh_subcommands=$(_completion_sync__completion_array "$ZSH_COMPLETION_FILE" subcommands)
bash_subcommands=$(_completion_sync__completion_array "$BASH_COMPLETION_FILE" subcommands)
zsh_config_types=$(_completion_sync__completion_array "$ZSH_COMPLETION_FILE" config_types)
bash_config_types=$(_completion_sync__completion_array "$BASH_COMPLETION_FILE" config_types)
zsh_config_actions=$(_completion_sync__completion_array "$ZSH_COMPLETION_FILE" config_actions)
bash_config_actions=$(_completion_sync__completion_array "$BASH_COMPLETION_FILE" config_actions)

assert_raises "_completion_sync__assert_lists_equal 'zsh subcommands' '$expected_subcommands' '$zsh_subcommands'" 0
assert_raises "_completion_sync__assert_lists_equal 'bash subcommands' '$expected_subcommands' '$bash_subcommands'" 0
assert_raises "_completion_sync__assert_lists_equal 'zsh config_types' '$expected_config_types' '$zsh_config_types'" 0
assert_raises "_completion_sync__assert_lists_equal 'bash config_types' '$expected_config_types' '$bash_config_types'" 0
assert_raises "_completion_sync__assert_lists_equal 'zsh config_actions' '$expected_config_actions' '$zsh_config_actions'" 0
assert_raises "_completion_sync__assert_lists_equal 'bash config_actions' '$expected_config_actions' '$bash_config_actions'" 0
