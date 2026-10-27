#!/usr/bin/env bash
set -euo pipefail

# System shutdown script with compositor awareness (Hyprland, Niri, or fallback).

TARGET_ACTION="poweroff"
DRY_RUN=0

for arg in "$@"; do
    case "$arg" in
        --dry-run)
            DRY_RUN=1
            ;;
        -r|--reboot|reboot)
            TARGET_ACTION="reboot"
            ;;
        -h|--help)
            echo "Usage: system-shutdown.sh [options]"
            echo ""
            echo "Options:"
            echo "  --dry-run       Show actions without shutting down"
            echo "  -r, --reboot    Reboot instead of power off"
            echo "  -h, --help      Show this help message"
            exit 0
            ;;
    esac
done

# Ensure NIRI_SOCKET is detected if running under Niri
detect_niri_socket() {
    if [ -n "${NIRI_SOCKET:-}" ] && [ -S "${NIRI_SOCKET}" ]; then
        return 0
    fi
    local uid
    uid="$(id -u)"
    for sock in /run/user/"${uid}"/niri*.sock; do
        if [ -S "${sock}" ]; then
            export NIRI_SOCKET="${sock}"
            return 0
        fi
    done
    return 1
}

# 1. Hyprland session
if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    if [ "${DRY_RUN}" -eq 1 ]; then
        exec hyprshutdown --dry-run
    fi
    exec hyprshutdown -t "Shutting down..." --post-cmd "systemctl ${TARGET_ACTION}"
fi

# 2. Niri session
if detect_niri_socket && niri msg version >/dev/null 2>&1; then
    # In interactive terminal, detach via systemd-run so terminal closure does not abort shutdown
    if [ "${DRY_RUN}" -eq 0 ] && [ -t 1 ] && [ -z "${SYSTEMD_TRANSIENT_SHUTDOWN:-}" ] && command -v systemd-run >/dev/null 2>&1; then
        exec systemd-run --user --collect --quiet \
            --setenv=NIRI_SOCKET="${NIRI_SOCKET}" \
            --setenv=WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-}" \
            --setenv=DISPLAY="${DISPLAY:-}" \
            --setenv=SYSTEMD_TRANSIENT_SHUTDOWN=1 \
            "$0" "$@"
    fi

    # Visual notification (non-blocking)
    if [ "${DRY_RUN}" -eq 0 ] && command -v notify-send >/dev/null 2>&1; then
        notify-send -u critical -a "Niri" "Shutting down..." "Closing applications and powering down" >/dev/null 2>&1 || true
    fi

    # Execute Python shutdown helper to gracefully close windows and exit Niri
    python3 - "$TARGET_ACTION" "$DRY_RUN" << 'EOF'
import json
import os
import subprocess
import sys
import time

action = sys.argv[1] if len(sys.argv) > 1 else "poweroff"
dry_run = sys.argv[2] == "1" if len(sys.argv) > 2 else False

def get_windows():
    try:
        res = subprocess.run(["niri", "msg", "-j", "windows"], capture_output=True, text=True, check=True)
        return json.loads(res.stdout)
    except Exception:
        return []

windows = get_windows()
if dry_run:
    print(f"[dry-run] Detected Niri session (socket: {os.environ.get('NIRI_SOCKET')})")
    print(f"[dry-run] Open windows ({len(windows)}):")
    for w in windows:
        print(f"  - [{w.get('id')}] {w.get('app_id', 'unknown')}: {w.get('title', 'untitled')}")
    print(f"[dry-run] Would send 'close-window' to {len(windows)} windows with 2.5s timeout.")
    print("[dry-run] Would execute: niri msg action quit -s")
    print(f"[dry-run] Would execute: systemctl {action}")
    sys.exit(0)

# Gracefully request every window to close
for w in windows:
    w_id = w.get("id")
    if w_id is not None:
        try:
            subprocess.run(["niri", "msg", "action", "close-window", "--id", str(w_id)], check=False)
        except Exception:
            pass

# Wait up to 2.5s for windows to terminate
if windows:
    deadline = time.time() + 2.5
    while time.time() < deadline:
        time.sleep(0.1)
        if not get_windows():
            break

# Exit Niri cleanly (triggers niri-shutdown.target in niri-session)
try:
    subprocess.run(["niri", "msg", "action", "quit", "-s"], check=False)
except Exception:
    pass

time.sleep(0.3)
EOF

    if [ "${DRY_RUN}" -eq 1 ]; then
        exit 0
    fi

    exec systemctl "${TARGET_ACTION}"
fi

# 3. Fallback (console/TTY or other window manager)
if [ "${DRY_RUN}" -eq 1 ]; then
    echo "[dry-run] Fallback session. Would execute: systemctl ${TARGET_ACTION}"
    exit 0
fi

exec systemctl "${TARGET_ACTION}"
