#!/usr/bin/env bash

# Test laptop_color_intent

assert_raises 'laptop_color_intent success' 0
assert 'LAPTOP_COLOR=true laptop_color_intent success' '\033[32m'
assert 'LAPTOP_COLOR=false laptop_color_intent success' ''
assert_raises 'laptop_color_intent error' 0
assert 'LAPTOP_COLOR=true laptop_color_intent error' '\033[31m'
assert 'LAPTOP_COLOR=false laptop_color_intent error' ''
assert_raises 'laptop_color_intent warn' 0
assert 'LAPTOP_COLOR=true laptop_color_intent warn' '\033[33m'
assert 'LAPTOP_COLOR=false laptop_color_intent warn' ''
assert_raises 'laptop_color_intent info' 0
assert 'LAPTOP_COLOR=true laptop_color_intent info' '\033[34m'
assert 'LAPTOP_COLOR=false laptop_color_intent info' ''
