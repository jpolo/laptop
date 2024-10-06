# Returns the location for the profile passed as parameter
#
# Usage:
#   laptop::profile_dir <profile_name>
#
laptop::profile_dir() {
  echo "$LAPTOP_PROFILE_DIR/${1:-$LAPTOP_PROFILE}"
}
