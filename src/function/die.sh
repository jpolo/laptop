#!/usr/bin/env bash

laptop::die() {
  laptop::error "$1"
  exit 1
}
