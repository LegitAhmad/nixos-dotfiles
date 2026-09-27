#!/usr/bin/env bash
set -euo pipefail

# Ensure single-instance execution to avoid race conditions from rapid keypresses
LOCKFILE="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/pc-sharing-toggle.lock"
exec 9>"$LOCKFILE"
if ! flock -n 9; then
  exit 0
fi

is_sharing_active() {
  systemctl --user is-active --quiet pc-sharing.target || \
  systemctl --user is-active --quiet lan-mouse.service || \
  systemctl --user is-active --quiet kdeconnect.service
}

stop_sharing() {
  systemctl --user stop pc-sharing.target lan-mouse.service kdeconnect.service || true
}

start_sharing() {
  if ! systemctl --user start pc-sharing.target; then
    stop_sharing
    notify-send -u critical "PC sharing failed" "Failed to start pc-sharing.target"
    return 1
  fi

  # Verify services become active
  local attempts=25
  while [ "$attempts" -gt 0 ]; do
    if systemctl --user is-active --quiet lan-mouse.service && systemctl --user is-active --quiet kdeconnect.service; then
      notify-send "PC sharing on"
      return 0
    fi
    sleep 0.2
    attempts=$((attempts - 1))
  done

  # Startup failed or timed out: tear down partially started services
  stop_sharing
  notify-send -u critical "PC sharing failed" "Sharing services did not start cleanly"
  return 1
}

if is_sharing_active; then
  stop_sharing
  notify-send "PC sharing off"
else
  start_sharing
fi
