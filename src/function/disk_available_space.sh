#!/usr/bin/env bash

laptop_disk_available_space() {
  df / | tail -1 | awk '{print $4}'
}
