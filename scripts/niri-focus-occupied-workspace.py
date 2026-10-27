#!/usr/bin/env python3
"""Switch to the next or previous non-empty workspace on the focused output in Niri."""

import json
import os
import socket
import subprocess
import sys


def get_socket_path():
    sock = os.environ.get("NIRI_SOCKET")
    if sock and os.path.exists(sock):
        return sock
    uid = os.getuid()
    run_user = f"/run/user/{uid}"
    if os.path.isdir(run_user):
        for entry in os.listdir(run_user):
            if entry.startswith("niri.") and entry.endswith(".sock"):
                candidate = os.path.join(run_user, entry)
                if os.path.exists(candidate):
                    return candidate
    return None


def niri_ipc(req):
    sock_path = get_socket_path()
    if sock_path:
        try:
            s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            s.connect(sock_path)
            s.sendall(json.dumps(req).encode("utf-8") + b"\n")
            buf = b""
            while True:
                chunk = s.recv(16384)
                buf += chunk
                if len(chunk) < 16384:
                    break
            s.close()
            data = json.loads(buf.decode("utf-8"))
            if "Ok" in data:
                return data["Ok"]
        except Exception:
            pass

    # Fallback to niri msg CLI if direct socket fails
    if req == "Workspaces":
        res = subprocess.run(["niri", "msg", "-j", "workspaces"], capture_output=True, text=True, check=True)
        return {"Workspaces": json.loads(res.stdout)}
    elif isinstance(req, dict) and "Action" in req:
        action = req["Action"]
        if "FocusWorkspace" in action:
            idx = action["FocusWorkspace"]["reference"]["Index"]
            subprocess.run(["niri", "msg", "action", "focus-workspace", str(idx)], check=True)
            return "Handled"
        elif "FocusWorkspaceDown" in action:
            subprocess.run(["niri", "msg", "action", "focus-workspace-down"], check=True)
            return "Handled"
        elif "FocusWorkspaceUp" in action:
            subprocess.run(["niri", "msg", "action", "focus-workspace-up"], check=True)
            return "Handled"
    return None


def main():
    direction = "down"
    wrap = "--wrap" in sys.argv or "-w" in sys.argv
    for arg in sys.argv[1:]:
        if arg in ("up", "down"):
            direction = arg

    data = niri_ipc("Workspaces")
    if not data or "Workspaces" not in data:
        sys.exit(0)

    workspaces = data["Workspaces"]
    focused = next((w for w in workspaces if w.get("is_focused")), None)
    if not focused:
        sys.exit(0)

    output = focused.get("output")
    current_idx = focused.get("idx")

    occupied = [
        w["idx"] for w in workspaces
        if w.get("output") == output and w.get("active_window_id") is not None
    ]
    occupied.sort()

    if not occupied:
        fallback = {"FocusWorkspaceDown": None} if direction == "down" else {"FocusWorkspaceUp": None}
        niri_ipc({"Action": fallback})
        sys.exit(0)

    target = None
    if direction == "down":
        candidates = [idx for idx in occupied if idx > current_idx]
        if candidates:
            target = candidates[0]
        elif wrap and occupied:
            target = occupied[0]
    else:
        candidates = [idx for idx in occupied if idx < current_idx]
        if candidates:
            target = candidates[-1]
        elif wrap and occupied:
            target = occupied[-1]
    if target is not None:
        niri_ipc({"Action": {"FocusWorkspace": {"reference": {"Index": target}}}})


if __name__ == "__main__":
    main()
