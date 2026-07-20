#!/usr/bin/env bash

laptop_require "laptop_package_ensure"

laptop_package_ensure__pack:data-utils() {
  laptop_package_ensure "dbt-core"
}
