#!/usr/bin/env bash

DATE_NOW_OUTPUT="$(laptop_date_now)"
assert_raises "[[ '$DATE_NOW_OUTPUT' =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]]" 0

assert "(date() { echo 'mock-date'; }; OSTYPE=darwin laptop_date_now)" "mock-date"
assert "(date() { echo 'mock-date'; }; OSTYPE=linux laptop_date_now)" "mock-date"
