laptop::profile_load() {
  local profile_file="$LAPTOP_PROFILE_DIR/$LAPTOP_PROFILE/profile.sh"
  if [ ! -f "$profile_file" ]; then
    laptop:die "Profile \"$LAPTOP_PROFILE\" does not exist"
  fi
  source "$profile_file"
}
