#!/usr/bin/env bash

laptop_require "laptop_mcp_ensure"

_MCP_STUB_DIR="$TEST_TMP_DIR/mcp_stubs"
_MCP_TOOLS_DIR="$TEST_TMP_DIR/mcp_tools"
_MCP_CURSOR_ARGS="$TEST_TMP_DIR/cursor_add_mcp.args"
_MCP_CODE_ARGS="$TEST_TMP_DIR/code_add_mcp.args"
_MCP_BASE_PATH="$_MCP_TOOLS_DIR:/bin:/usr/bin:/usr/sbin:/sbin"

_mcp_test_setup_tools() {
  mkdir -p "$_MCP_TOOLS_DIR"
  ln -sf "$(command -v jq)" "$_MCP_TOOLS_DIR/jq"
}

_mcp_test_setup_stubs() {
  mkdir -p "$_MCP_STUB_DIR"
  rm -f "$_MCP_CURSOR_ARGS" "$_MCP_CODE_ARGS"

  cat >"$_MCP_STUB_DIR/cursor" <<EOF
#!/usr/bin/env bash
printf '%s\n' "\$@" >> $(quote "$_MCP_CURSOR_ARGS")
EOF
  chmod +x "$_MCP_STUB_DIR/cursor"

  cat >"$_MCP_STUB_DIR/code" <<EOF
#!/usr/bin/env bash
printf '%s\n' "\$@" >> $(quote "$_MCP_CODE_ARGS")
EOF
  chmod +x "$_MCP_STUB_DIR/code"
}

_mcp_test_path_with_stubs() {
  echo "$_MCP_STUB_DIR:$_MCP_BASE_PATH"
}

_mcp_test_path_empty() {
  echo "$_MCP_BASE_PATH"
}

_mcp_test_cursor_ide_file() {
  laptop_mcp_ide_config_path "Cursor"
}

_mcp_test_code_ide_file() {
  laptop_mcp_ide_config_path "Code"
}

_mcp_test_setup_tools
_mcp_test_setup_stubs

# Avoid writing under ~/.cursor (sandbox may block that path)
export LAPTOP_CURSOR_MCP_FILE="$TEST_TMP_DIR/cursor_agent_mcp.json"

# --- provider resolution ---

# auto with no CLIs on PATH returns empty
assert "PATH='$(_mcp_test_path_empty)' laptop_mcp_providers auto" ""

# auto sniffs only candidate CLIs present on PATH
assert "PATH='$(_mcp_test_path_with_stubs)' laptop_mcp_providers auto" "cursor code"

# auto with only cursor
rm -f "$_MCP_STUB_DIR/code"
assert "PATH='$(_mcp_test_path_with_stubs)' laptop_mcp_providers auto" "cursor"
_mcp_test_setup_stubs

# unset LAPTOP_MCP_PROVIDERS defaults to auto
unset LAPTOP_MCP_PROVIDERS
assert "PATH='$(_mcp_test_path_with_stubs)' laptop_mcp_providers" "cursor code"

# explicit args override LAPTOP_MCP_PROVIDERS
export LAPTOP_MCP_PROVIDERS="code"
assert "laptop_mcp_providers cursor" "cursor"
assert "PATH='$(_mcp_test_path_with_stubs)' laptop_mcp_providers" "code"
unset LAPTOP_MCP_PROVIDERS

# comma-separated env list
export LAPTOP_MCP_PROVIDERS="cursor,code"
assert "laptop_mcp_providers" "cursor code"
unset LAPTOP_MCP_PROVIDERS

# --- Cursor provider ---

_mcp_test_setup_stubs
rm -f "$LAPTOP_CURSOR_MCP_FILE"
rm -rf "$(dirname "$(_mcp_test_cursor_ide_file)")"
mkdir -p "$(dirname "$(_mcp_test_cursor_ide_file)")"

# Cursor installs when absent: writes agent file and calls cursor --add-mcp
assert_raises "PATH='$(_mcp_test_path_with_stubs)' laptop_mcp_ensure 'notion' 'https://mcp.notion.com/mcp' cursor" 0
assert "jq -r '.mcpServers.notion.url' '$LAPTOP_CURSOR_MCP_FILE'" "https://mcp.notion.com/mcp"
assert "cat '$_MCP_CURSOR_ARGS'" "--add-mcp
{\"name\":\"notion\",\"url\":\"https://mcp.notion.com/mcp\"}"

# Cursor skips both writes when already present
rm -f "$_MCP_CURSOR_ARGS"
# Seed IDE config as present
cat >"$(_mcp_test_cursor_ide_file)" <<'EOF'
{"mcpServers":{"notion":{"url":"https://mcp.notion.com/mcp"}}}
EOF
assert_raises "PATH='$(_mcp_test_path_with_stubs)' laptop_mcp_ensure 'notion' 'https://mcp.notion.com/mcp' cursor" 0
assert_raises "test -f '$_MCP_CURSOR_ARGS'" 1

# --- VS Code provider ---

_mcp_test_setup_stubs
rm -rf "$(dirname "$(_mcp_test_code_ide_file)")"
mkdir -p "$(dirname "$(_mcp_test_code_ide_file)")"

# VS Code installs with type=http when absent
assert_raises "PATH='$(_mcp_test_path_with_stubs)' laptop_mcp_ensure 'notion' 'https://mcp.notion.com/mcp' code" 0
assert "cat '$_MCP_CODE_ARGS'" "--add-mcp
{\"name\":\"notion\",\"type\":\"http\",\"url\":\"https://mcp.notion.com/mcp\"}"

# VS Code skips when already present
rm -f "$_MCP_CODE_ARGS"
cat >"$(_mcp_test_code_ide_file)" <<'EOF'
{"servers":{"notion":{"type":"http","url":"https://mcp.notion.com/mcp"}}}
EOF
assert_raises "PATH='$(_mcp_test_path_with_stubs)' laptop_mcp_ensure 'notion' 'https://mcp.notion.com/mcp' code" 0
assert_raises "test -f '$_MCP_CODE_ARGS'" 1

# --- unknown provider fails; implemented provider still runs ---

_mcp_test_setup_stubs
rm -f "$LAPTOP_CURSOR_MCP_FILE" "$_MCP_CURSOR_ARGS"
assert_raises "PATH='$(_mcp_test_path_with_stubs)' laptop_mcp_ensure 'linear' 'https://mcp.linear.app/mcp' cursor unknown-provider" 1
assert "jq -r '.mcpServers.linear.url' '$LAPTOP_CURSOR_MCP_FILE'" "https://mcp.linear.app/mcp"
assert "cat '$_MCP_CURSOR_ARGS'" "--add-mcp
{\"name\":\"linear\",\"url\":\"https://mcp.linear.app/mcp\"}"
