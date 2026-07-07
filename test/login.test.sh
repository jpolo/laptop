#!/usr/bin/env bash

# Test the `laptop_command__login` wrapper using a temporary profile

mkdir -p "$LAPTOP_HOME/profile/test-profile/login.d"
cat > "$LAPTOP_HOME/profile/test-profile/login.d/0-test.sh" <<'EOF'
#!/usr/bin/env zsh
echo "login-step-run"
exit 0
EOF
chmod +x "$LAPTOP_HOME/profile/test-profile/login.d/0-test.sh"

# Run the step script directly to verify it executes successfully.
assert_raises "zsh \"$LAPTOP_HOME/profile/test-profile/login.d/0-test.sh\"" 0
