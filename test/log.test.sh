#!/usr/bin/env bash

assert "laptop_log info 'Test info message'" "Info: Test info message"
assert "laptop_log warn 'Test warn message'" "Warning: Test warn message"
assert "laptop_log error 'Test error message'" "Error: Test error message"
assert "laptop_log unknown 'Test unknown message'" "Unknown: Test unknown message"
