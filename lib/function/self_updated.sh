#!/usr/bin/env bash

laptop_require "laptop_brew_package_installed"
laptop_require "laptop_date_now"
laptop_require "laptop_date_to_epoch"
laptop_require "laptop_die"
laptop_require "laptop_file_var_get"
laptop_require "laptop_file_var_set"
laptop_require "laptop_self_version"

# Check whether laptop is up-to-date, with optional TTL-based caching.
#
# Usage:
#   laptop_self_updated [--cache-max-age cache_max_age_seconds]
#
# When no argument is provided:
#   - cache reads are disabled
#   - a live check is always performed
#   - the result is still written to the XDG cache dir
#
# When an argument is provided:
#   - it is treated as cache max age in seconds
#   - invalid values exit with an error
#   - a cached "outdated" result remains sticky until the laptop version changes
#
laptop_self_updated() {
  local cache_max_age_seconds=""
  local current_version
  local cached_version
  local cached_at
  local cached_outdated
  local live_status=0
  local now_epoch
  local cached_epoch
  local age_seconds

  if [[ "$#" -gt 0 ]]; then
    if [[ "$1" != "--cache-max-age" ]] || [[ "$#" -ne 2 ]]; then
      laptop_die "Usage: laptop_self_updated [--cache-max-age cache_max_age_seconds]"
    fi
    cache_max_age_seconds="$2"
  fi

  if [[ -n "$cache_max_age_seconds" ]] && [[ ! "$cache_max_age_seconds" =~ ^[0-9]+$ ]]; then
    laptop_die "Invalid cache max age for laptop_self_updated: '$cache_max_age_seconds'. Must be a non-negative integer."
  fi

  current_version="$(laptop_self_version)"

  # Cache is disabled if no TTL argument is provided.
  if [[ -n "$cache_max_age_seconds" ]]; then
    cached_version="$(_laptop_self_updated_cache_get "version")"
    cached_at="$(_laptop_self_updated_cache_get "checked_at")"
    cached_outdated="$(_laptop_self_updated_cache_get "outdated")"

    if [[ -n "$cached_version" ]] && [[ "$cached_version" == "$current_version" ]] && [[ -n "$cached_at" ]]; then
      if [[ "$cached_outdated" == "1" ]]; then
        return 1
      fi

      if [[ "$cached_outdated" == "0" ]]; then
        now_epoch="$(laptop_date_to_epoch "$(laptop_date_now)")"
        cached_epoch="$(laptop_date_to_epoch "$cached_at")"

        if [[ -n "$now_epoch" ]] && [[ -n "$cached_epoch" ]]; then
          age_seconds=$((now_epoch - cached_epoch))
          if (( age_seconds <= cache_max_age_seconds )); then
            return 0
          fi
        fi
      fi
    fi
  fi

  if ! _laptop_self_updated_live_check; then
    live_status=1
  fi

  _laptop_self_updated_cache_set "version" "$current_version"
  _laptop_self_updated_cache_set "checked_at" "$(laptop_date_now)"
  _laptop_self_updated_cache_set "outdated" "$live_status"

  return "$live_status"
}

# Cache file is XDG cache dir scoped so it can be wiped at any time without side effects.
_laptop_self_updated_cache_file() {
  echo "$LAPTOP_USER_CACHE_DIR/outdated-check.cache"
}

_laptop_self_updated_cache_get() {
  local key="$1"
  laptop_file_var_get "$(_laptop_self_updated_cache_file)" "$key"
}

_laptop_self_updated_cache_set() {
  local key="$1"
  local value="$2"
  mkdir -p "$LAPTOP_USER_CACHE_DIR"
  laptop_file_var_set "$(_laptop_self_updated_cache_file)" "$key" "$value"
}

_laptop_self_updated_live_check() {
  local current_branch
  local remote_sha
  local local_sha

  # Homebrew install (--HEAD): check if upstream has new commits
  # --fetch-HEAD is required for HEAD formulae; HOMEBREW_NO_AUTO_UPDATE=1 avoids slow tap updates
  if [[ -n "$LAPTOP_INSTALL_BREW_PACKAGE" ]]; then
    if HOMEBREW_NO_AUTO_UPDATE=1 brew outdated --quiet --fetch-HEAD "$LAPTOP_INSTALL_BREW_PACKAGE" 2>/dev/null | grep -q .; then
      return 1 # Outdated
    fi
    return 0 # Up-to-date
  fi

  # Git install (e.g. zimfw or manual clone): check if remote is ahead
  # Use ls-remote instead of fetch so we don't download objects on every check
  if [[ -d "$LAPTOP_HOME/.git" ]]; then
    current_branch=$(git -C "$LAPTOP_HOME" rev-parse --abbrev-ref HEAD 2>/dev/null)
    [[ -z "$current_branch" ]] && return 0

    remote_sha=$(git -C "$LAPTOP_HOME" ls-remote origin "$current_branch" 2>/dev/null | cut -f1)
    [[ -z "$remote_sha" ]] && return 0 # Can't tell, assume up-to-date

    local_sha=$(git -C "$LAPTOP_HOME" rev-parse HEAD 2>/dev/null)
    # Behind = local is ancestor of remote and not equal
    if [[ -n "$local_sha" ]] && git -C "$LAPTOP_HOME" merge-base --is-ancestor HEAD "$remote_sha" 2>/dev/null && [[ "$local_sha" != "$remote_sha" ]]; then
      return 1 # Outdated
    fi
  fi

  return 0 # Up-to-date
}
