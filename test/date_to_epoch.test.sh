#!/usr/bin/env bash

assert "laptop_date_to_epoch '1970-01-01T00:00:00Z'" "0"
assert "laptop_date_to_epoch 'not-a-timestamp'" ""

assert "(date() { echo 'mock-date'; }; OSTYPE=darwin laptop_date_to_epoch 'timestamp')" "mock-date"
assert "(date() { echo 'mock-date'; }; OSTYPE=linux laptop_date_to_epoch 'timestamp')" "mock-date"
