laptop::profile_available() {
  echo "$LAPTOP_PROFILE_DEFAULT"
  ls "$LAPTOP_PROFILE_DIR" | grep -v "$LAPTOP_PROFILE_DEFAULT" | sort
}
