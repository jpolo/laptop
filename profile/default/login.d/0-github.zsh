#!/usr/bin/env zsh

# Default GitHub login step for the `login` command
# Uses the existing `laptop_github_ensure_login` function.

laptop_github_ensure_login

# Configure ssh
# laptop_ssh_ensure_key "ed25519" # FIXME: this creates a new key without password, which is refused by github
laptop_ssh_ensure_setting "Host *" "IdentityFile" "~/.ssh/id_ed25519"

# Login using GITHUB_TOKEN to npm github npm.pkg.github.com
# shellcheck disable=SC2016
laptop_shell_ensure_var "$HOME/.profile" "GITHUB_TOKEN" '"$(GITHUB_TOKEN= gh auth token 2>/dev/null)"' --export

# Keep variable references in .npmrc so token updates do not require rewrites.
# shellcheck disable=SC2016
laptop_npm_config_ensure "//npm.pkg.github.com/:_authToken" '${GITHUB_TOKEN}'
