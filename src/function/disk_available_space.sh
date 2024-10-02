laptop::disk_available_space() {
  df / | tail -1 | awk '{print $4}'
}
