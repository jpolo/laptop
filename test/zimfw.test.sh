#!/usr/bin/env bash

laptop_require "laptop_command_exists"
source "$LAPTOP_HOME/lib/command/upgrade.sh"
source "$LAPTOP_HOME/lib/command/cleanup.sh"

assert_raises "(env() { [[ \"\$1\" == zsh && \"\$2\" == --login && \"\$3\" == -i && \"\$4\" == -c && \"\$5\" == 'command -v \"zimfw\"' && \"\$TEST_ZIMFW_AVAILABLE\" == yes ]]; }; TEST_ZIMFW_AVAILABLE=yes laptop_command_exists zimfw)" 0
assert_raises "(env() { [[ \"\$1\" == zsh && \"\$2\" == --login && \"\$3\" == -i && \"\$4\" == -c && \"\$5\" == 'command -v \"zimfw\"' && \"\$TEST_ZIMFW_AVAILABLE\" == yes ]]; }; TEST_ZIMFW_AVAILABLE=no laptop_command_exists zimfw)" 1
assert_raises "(env() { [[ \"\$1\" == zsh && \"\$2\" == --login && \"\$3\" == -i && \"\$4\" == -c && \"\$5\" == 'command -v \"zinit\"' && \"\$TEST_ZINIT_AVAILABLE\" == yes ]]; }; TEST_ZINIT_AVAILABLE=yes laptop_command_exists zinit)" 0
assert_raises "(env() { [[ \"\$1\" == zsh && \"\$2\" == --login && \"\$3\" == -i && \"\$4\" == -c && \"\$5\" == 'command -v \"zinit\"' && \"\$TEST_ZINIT_AVAILABLE\" == yes ]]; }; TEST_ZINIT_AVAILABLE=no laptop_command_exists zinit)" 1
assert_raises '[[ " ${__LAPTOP_UPGRADE_TOOLS[*]} " == *" zinit "* && " ${__LAPTOP_CLEANUP_TOOLS[*]} " == *" zinit "* ]]' 0

assert "(laptop_step_upgrade_start() { printf 'start:%s\\n' \"\$1\"; }; laptop_step_eval() { printf 'eval:%s\\n' \"\$1\"; }; laptop_zimfw_ensure_updated)" $'start:zimfw updated\neval:env zsh --login -i -c "zimfw update && zimfw upgrade"'

assert "(laptop_step_upgrade_start() { printf 'start:%s\\n' \"\$1\"; }; laptop_step_eval() { printf 'eval:%s\\n' \"\$1\"; }; laptop_zinit_ensure_updated)" $'start:zinit updated\neval:env zsh --login -i -c "zinit update --all"'

assert "(laptop_filter_command_exists() { printf 'zimfw'; }; laptop_xcode_ensure_license_accepted() { :; }; laptop_zimfw_ensure_updated() { printf 'zimfw route'; }; laptop_self_command_touch() { :; }; laptop_command__upgrade_run)" "zimfw route"

assert "(laptop_filter_command_exists() { printf 'zinit'; }; laptop_xcode_ensure_license_accepted() { :; }; laptop_zinit_ensure_updated() { printf 'zinit route'; }; laptop_self_command_touch() { :; }; laptop_command__upgrade_run)" "zinit route"

assert "(laptop_filter_command_exists() { printf 'zimfw'; }; laptop_disk_available_space() { printf '100'; }; laptop_step_start() { printf 'start:%s\\n' \"\$1\"; }; laptop_step_eval() { printf 'eval:%s\\n' \"\$1\"; }; laptop_directory_ensure_empty() { :; }; laptop_command__cleanup_result() { :; }; laptop_self_command_touch() { :; }; laptop_command__cleanup_run)" $'start:- Cleanup zimfw\neval:env zsh --login -i -c "zimfw clean"'

assert "(laptop_filter_command_exists() { printf 'zinit'; }; laptop_disk_available_space() { printf '100'; }; laptop_step_start() { printf 'start:%s\\n' \"\$1\"; }; laptop_step_eval() { printf 'eval:%s\\n' \"\$1\"; }; laptop_directory_ensure_empty() { :; }; laptop_command__cleanup_result() { :; }; laptop_self_command_touch() { :; }; laptop_command__cleanup_run)" $'start:- Cleanup zinit\neval:env zsh --login -i -c "zinit cclear; zinit delete --clean --quiet --yes"'

zimfw_startup_smoke_test() {
  local smoke_home="$TEST_TMP_DIR/zimfw-startup"
  local config_home="$smoke_home/.config"
  local data_home="$smoke_home/.local/share"
  local zim_home="$config_home/zim"

  rm -rf "$smoke_home"
  mkdir -p "$config_home/zsh/init.d" "$data_home/zsh" "$zim_home" "$smoke_home/.local/state/zsh"
  cp "$LAPTOP_HOME/profile/default/resource/.zshrc" "$smoke_home/.zshrc"
  cp "$LAPTOP_HOME/profile/default/resource/.config/zim/zimrc" "$zim_home/zimrc"
  cp "$LAPTOP_HOME/profile/default/resource/.config/zsh/init.d/global.sh" "$config_home/zsh/init.d/global.sh"
  printf ':\n' > "$smoke_home/.zprofile"
  printf 'export ZIMFW_TEST_CONFIG=loaded\n' > "$config_home/zsh/init"
  printf 'export ZIMFW_TEST_DATA=loaded\n' > "$data_home/zsh/init"
  printf 'export ZIMFW_TEST_LOCAL=loaded\n' > "$smoke_home/.zshrc.local"
  printf 'print '\''export ZIMFW_TEST_INIT=loaded'\'' > "$ZIM_HOME/init.zsh"\n' > "$zim_home/zimfw.zsh"

  env HOME="$smoke_home" \
    PATH="$smoke_home/bin:/usr/bin:/bin" \
    XDG_CONFIG_HOME="$config_home" \
    XDG_DATA_HOME="$data_home" \
    XDG_CACHE_HOME="$smoke_home/.cache" \
    XDG_STATE_HOME="$smoke_home/.local/state" \
    ZIM_HOME="$zim_home" \
    ZIM_CONFIG_FILE="$zim_home/zimrc" \
    HISTFILE="$smoke_home/.local/state/zsh/history" \
    zsh -f -c 'source "$HOME/.zshrc"; [[ "$ZIMFW_TEST_INIT" == loaded && "$ZIMFW_TEST_CONFIG" == loaded && "$ZIMFW_TEST_DATA" == loaded && "$ZIMFW_TEST_LOCAL" == loaded ]]'
}

assert_raises "zimfw_startup_smoke_test" 0