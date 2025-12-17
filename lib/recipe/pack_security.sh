#!/usr/bin/env bash

laptop_require "laptop_package_ensure"

laptop_package_ensure__pack:security() {
  laptop_package_ensure "macpass"
}
