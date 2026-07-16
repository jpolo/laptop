#!/usr/bin/env bash

laptop_disk_available_space() {
  df -k / | awk 'NR==2 {print $4}'
}
