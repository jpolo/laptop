#!/usr/bin/env bash

# Test laptop_directory_ensure

# remove color and check that the output contains $OK_STATUS
laptop_directory_ensure "$TMPDIR/folder_create/"
laptop_directory_ensure "$TMPDIR/folder_create/"

# Test laptop_file_ensure
laptop_file_ensure "$TMPDIR/test_file_create"
laptop_file_ensure "$TMPDIR/test_file_create"
