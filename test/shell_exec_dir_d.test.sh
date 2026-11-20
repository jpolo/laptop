#!/usr/bin/env bash

# Steps launched by laptop_shell_exec_dir_d must keep the terminal on stdin.
# The acli site picker enters raw mode only when stdin is a terminal. If the
# file list stays on stdin, arrow keys are echoed as ^[[B and never select a row.

shell_exec_dir_d_steps="$TEST_TMP_DIR/shell-exec-dir-d"
mkdir -p "$shell_exec_dir_d_steps"

cat >"$shell_exec_dir_d_steps/00-probe.zsh" <<'EOF'
#!/usr/bin/env zsh
/usr/bin/python3 -c 'import os, sys, select, termios, tty
raw = os.isatty(0)
old = termios.tcgetattr(0) if raw else None
if raw:
    tty.setraw(0)
print("READY", int(raw), flush=True)
try:
    ready, _, _ = select.select([0], [], [], 1.0)
    data = os.read(0, 64) if ready else b""
finally:
    if raw and old is not None:
        termios.tcsetattr(0, termios.TCSADRAIN, old)
print("KEY", data.hex(), flush=True)
'
EOF

cat >"$shell_exec_dir_d_steps/01-later.zsh" <<'EOF'
#!/usr/bin/env zsh
print SECOND_OK
EOF

cat >"$TEST_TMP_DIR/shell-exec-dir-d-loop.py" <<'EOF'
import os
import pty
import select
import subprocess
import sys
import time

steps = os.environ["SHELL_EXEC_DIR_D_STEPS"]
laptop = os.environ["LAPTOP_HOME"]
master, slave = pty.openpty()
env = os.environ.copy()
env["TERM"] = "xterm-256color"
env["LAPTOP_PROFILE"] = env.get("LAPTOP_PROFILE", "default")
env["LAPTOP_SOURCE_ALL"] = "true"
env["LAPTOP_DEVCONTAINER"] = "false"
env["ZDOTDIR"] = env["HOME"]
script = f'''
source "{laptop}/lib/init.sh"
laptop_shell_exec_dir_d zsh "{steps}"
'''
proc = subprocess.Popen(
    ["bash", "-c", script],
    stdin=slave,
    stdout=slave,
    stderr=slave,
    env=env,
    close_fds=True,
)
os.close(slave)
buf = b""
sent = False
deadline = time.time() + 25
while time.time() < deadline:
    ready, _, _ = select.select([master], [], [], 0.2)
    if ready:
        try:
            chunk = os.read(master, 4096)
        except OSError:
            break
        if not chunk:
            break
        buf += chunk
        if not sent and b"READY" in buf:
            time.sleep(0.05)
            os.write(master, b"\x1b[B")
            sent = True
    elif proc.poll() is not None:
        break
try:
    proc.wait(timeout=5)
except subprocess.TimeoutExpired:
    proc.kill()
    proc.wait()
os.close(master)
text = buf.decode("utf-8", "replace")
ok = (
    "READY 1" in text
    and "KEY 1b5b42" in text
    and "SECOND_OK" in text
    and "^[[B" not in text
)
if not ok:
    sys.stderr.write(text)
    sys.exit(1)
EOF

SHELL_EXEC_DIR_D_STEPS="$shell_exec_dir_d_steps" \
  assert_raises "/usr/bin/python3 \"$TEST_TMP_DIR/shell-exec-dir-d-loop.py\"" 0
