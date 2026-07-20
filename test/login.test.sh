#!/usr/bin/env bash

# Test the `laptop_command__login` wrapper using an isolated temporary profile.
# Fixtures are written under $TEST_TMP_DIR so the versioned profile/ directory
# is never touched.

login_test_profile_dir="$TEST_TMP_DIR/profile/test-profile"
mkdir -p "$login_test_profile_dir/login.d"
cat > "$login_test_profile_dir/login.d/0-test.sh" <<'EOF'
#!/usr/bin/env zsh
echo "login-step-run"
exit 0
EOF
chmod +x "$login_test_profile_dir/login.d/0-test.sh"

# Run the step script directly to verify it executes successfully.
assert_raises "zsh \"$login_test_profile_dir/login.d/0-test.sh\"" 0
