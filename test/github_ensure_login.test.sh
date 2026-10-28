#!/usr/bin/env bash

# Exact scopes match.
assert_raises "_laptop_github_scopes_include_all 'gist, read:org, repo' 'gist, read:org, repo'" 0

# admin:org implies read:org, so a token with admin:org satisfies read:org.
assert_raises "_laptop_github_scopes_include_all 'admin:org, gist, repo, write:packages' 'gist, read:org, repo, write:packages'" 0

# write:X implies read:X.
assert_raises "_laptop_github_scopes_include_all 'write:packages' 'read:packages'" 0

# A genuinely missing scope still fails.
assert_raises "_laptop_github_scopes_include_all 'gist, repo' 'gist, read:org, repo'" 1

# A broader scope does not satisfy an unrelated scope.
assert_raises "_laptop_github_scopes_include_all 'admin:org' 'admin:repo_hook'" 1
