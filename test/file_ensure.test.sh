#!/usr/bin/env bash

# Test laptop_directory_ensure

assert_raises "laptop_directory_ensure '$TMPDIR/folder_create/'" 0
assert "file -b $TMPDIR/folder_create/" "directory"
assert_raises "laptop_directory_ensure '$TMPDIR/folder_create/'" 0
assert "file -b $TMPDIR/folder_create/" "directory"

# Test laptop_file_ensure
laptop_file_ensure "$TMPDIR/test_file_create"
laptop_file_ensure "$TMPDIR/test_file_create"
