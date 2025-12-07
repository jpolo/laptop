#!/usr/bin/env bash

# Example
#
# assert_snapshot "my-command" "my-command.out"
assert_snapshot() {
  local test_command="$1"
  local snapshot_file;
  local snapshot_content;
  snapshot_file="$LAPTOP_TEST_DIR/__snapshots__/$2"

  if [[ "$UPDATE_SNAPSHOT" != "" || ! -f $snapshot_file ]];then
    mkdir -p "$(dirname "$snapshot_file")"
    eval "$test_command" > "$snapshot_file"
  fi
  snapshot_content=$(cat "$snapshot_file")

  assert "$test_command" "$snapshot_content"
}
