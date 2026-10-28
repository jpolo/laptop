#!/usr/bin/env bash

MISE_TEST_VERSIONS="$TEST_TMP_DIR/mise-tool-versions"
MISE_TEST_CALLS="$TEST_TMP_DIR/mise-calls"
MISE_TEST_PROFILE="$TEST_TMP_DIR/mise-profile"
mkdir -p "$MISE_TEST_PROFILE"
printf 'nodejs 24.18.0\npython 3.14.6\n' >"$MISE_TEST_VERSIONS"
: >"$MISE_TEST_CALLS"

# shellcheck disable=SC2329 # invoked indirectly by laptop_mise_ensure_package
mise() {
  printf '%s\n' "$*" >>"$MISE_TEST_CALLS"
}

laptop_mise_ensure_package_list "$MISE_TEST_VERSIONS" >/dev/null
assert "cat '$MISE_TEST_CALLS'" $'use --global node@24.18.0\nuse --global python@3.14.6'

source "$LAPTOP_HOME/lib/package/mise.sh"
(
  laptop_brew_ensure_package() {
    printf 'brew %s\n' "$*" >>"$MISE_TEST_CALLS"
  }
  LAPTOP_PACKAGE_MANAGER="brew" laptop_package_ensure__mise mise
  LAPTOP_PACKAGE_MANAGER="brew" laptop_package_ensure__mise mise --status absent
)
assert "tail -n 2 '$MISE_TEST_CALLS'" $'brew mise mise\nbrew mise mise --status absent'

source "$LAPTOP_HOME/lib/package/pack_core.sh"
MISE_TEST_PACK_CALLS="$TEST_TMP_DIR/mise-pack-calls"
(
  laptop_package_ensure() {
    printf '%s\n' "$*"
  }
  LAPTOP_TOOL_MANAGER="mise"
  laptop_package_ensure__pack:core
) >"$MISE_TEST_PACK_CALLS"
assert_raises "grep -Fx 'mise --status present' '$MISE_TEST_PACK_CALLS'" 0
assert_raises "grep -Fx 'asdf --status absent' '$MISE_TEST_PACK_CALLS'" 0

(
  laptop_package_ensure() {
    printf '%s\n' "$*"
  }
  LAPTOP_TOOL_MANAGER="asdf"
  laptop_package_ensure__pack:core
) >"$MISE_TEST_PACK_CALLS"
assert_raises "grep -Fx 'asdf --status present' '$MISE_TEST_PACK_CALLS'" 0
assert_raises "grep -Fx 'mise --status absent' '$MISE_TEST_PACK_CALLS'" 0

source "$LAPTOP_HOME/lib/package/profile_core.sh"

(
  laptop_profile_dir() {
    printf '%s\n' "$MISE_TEST_PROFILE"
  }
  laptop_npm_ensure_package_list() {
    :
  }
  laptop_mise_ensure_package_list() {
    printf 'mise\n' >>"$MISE_TEST_CALLS"
  }
  laptop_asdf_ensure_package_list() {
    printf 'asdf\n' >>"$MISE_TEST_CALLS"
  }
  # shellcheck disable=SC2329 # invoked indirectly by laptop_tool_manager
  command() {
    if [[ "$1" == "-v" && "$2" == "mise" ]]; then
      return 0
    fi
    if [[ "$1" == "-v" && "$2" == "asdf" ]]; then
      return 0
    fi
    builtin command "$@"
  }
  unset LAPTOP_TOOL_MANAGER
  laptop_package_ensure__profile:core
)
assert "tail -n 1 '$MISE_TEST_CALLS'" "mise"

(
  laptop_profile_dir() {
    printf '%s\n' "$MISE_TEST_PROFILE"
  }
  laptop_npm_ensure_package_list() {
    :
  }
  laptop_mise_ensure_package_list() {
    printf 'mise\n' >>"$MISE_TEST_CALLS"
  }
  laptop_asdf_ensure_package_list() {
    printf 'asdf\n' >>"$MISE_TEST_CALLS"
  }
  # shellcheck disable=SC2329 # invoked indirectly by laptop_tool_manager
  command() {
    if [[ "$1" == "-v" && "$2" == "mise" ]]; then
      return 1
    fi
    if [[ "$1" == "-v" && "$2" == "asdf" ]]; then
      return 0
    fi
    builtin command "$@"
  }
  unset LAPTOP_TOOL_MANAGER
  laptop_package_ensure__profile:core
)
assert "tail -n 1 '$MISE_TEST_CALLS'" "asdf"

(
  laptop_profile_dir() {
    printf '%s\n' "$MISE_TEST_PROFILE"
  }
  laptop_npm_ensure_package_list() {
    :
  }
  laptop_mise_ensure_package_list() {
    printf 'mise\n' >>"$MISE_TEST_CALLS"
  }
  laptop_asdf_ensure_package_list() {
    printf 'asdf\n' >>"$MISE_TEST_CALLS"
  }
  # shellcheck disable=SC2329 # invoked indirectly by laptop_tool_manager
  command() {
    if [[ "$1" == "-v" && "$2" == "mise" ]]; then
      return 0
    fi
    if [[ "$1" == "-v" && "$2" == "asdf" ]]; then
      return 0
    fi
    builtin command "$@"
  }
  LAPTOP_TOOL_MANAGER="asdf"
  laptop_package_ensure__profile:core
)
assert "tail -n 1 '$MISE_TEST_CALLS'" "asdf"

source "$LAPTOP_HOME/lib/function/mise_ensure_updated.sh"
(
  laptop_step_upgrade_start() {
    printf 'start %s\n' "$*" >>"$MISE_TEST_CALLS"
  }
  laptop_step_status() {
    printf 'status %s\n' "$*" >>"$MISE_TEST_CALLS"
  }
  mise() {
    printf 'mise %s\n' "$*" >>"$MISE_TEST_CALLS"
  }
  LAPTOP_PACKAGE_MANAGER="brew"
  laptop_mise_ensure_updated
  LAPTOP_PACKAGE_MANAGER="apt-get"
  laptop_mise_ensure_updated
)
assert_raises "grep -Fx 'start mise updated' '$MISE_TEST_CALLS'" 0
assert_raises "grep -Fx 'mise self-update --yes' '$MISE_TEST_CALLS'" 0

source "$LAPTOP_HOME/lib/command/config.sh"
assert "MISE_CONFIG_DIR='$TEST_TMP_DIR/mise-config'; laptop_command__config path mise" "$TEST_TMP_DIR/mise-config/config.toml"
assert "laptop_command__config path asdf" "$HOME/.tool-versions"

source "$LAPTOP_HOME/lib/package/config_asdf-recommended.sh"
MISE_TEST_PLUGIN_CALLS="$TEST_TMP_DIR/mise-plugin-calls"
(
  laptop_asdf_ensure_plugin() {
    printf '%s\n' "$1" >>"$MISE_TEST_PLUGIN_CALLS"
  }
  laptop_log() {
    :
  }
  : >"$MISE_TEST_PLUGIN_CALLS"
  LAPTOP_TOOL_MANAGER="mise"
  laptop_package_ensure__config:asdf-recommended
)
assert_raises "test ! -s '$MISE_TEST_PLUGIN_CALLS'" 0

(
  laptop_asdf_ensure_plugin() {
    printf '%s\n' "$1" >>"$MISE_TEST_PLUGIN_CALLS"
  }
  laptop_log() {
    :
  }
  : >"$MISE_TEST_PLUGIN_CALLS"
  LAPTOP_TOOL_MANAGER="asdf"
  laptop_package_ensure__config:asdf-recommended
)
assert_raises "grep -Fx java '$MISE_TEST_PLUGIN_CALLS'" 0
assert_raises "grep -Fx nodejs '$MISE_TEST_PLUGIN_CALLS'" 0
assert_raises "grep -Fx ruby '$MISE_TEST_PLUGIN_CALLS'" 0

assert_raises "(laptop_package_ensure__mise_test_failure() { return 42; }; laptop_package_ensure mise_test_failure)" 42

unset -f mise
