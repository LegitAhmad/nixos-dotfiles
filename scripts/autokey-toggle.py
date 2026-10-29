#!/usr/bin/env python3
import fcntl
import os
import signal
import struct
import subprocess
import sys
import time

# Linux input / uinput constants
UI_SET_EVBIT = 0x40045564
UI_SET_KEYBIT = 0x40045565
UI_DEV_CREATE = 0x5501
UI_DEV_DESTROY = 0x5502
UI_DEV_SETUP = 0x405C5503

EV_SYN = 0x00
EV_KEY = 0x01
SYN_REPORT = 0
BUS_USB = 0x03

KEY_MAP = {
    "esc": 1,
    "1": 2, "2": 3, "3": 4, "4": 5, "5": 6, "6": 7, "7": 8, "8": 9, "9": 10, "0": 11,
    "q": 16, "w": 17, "e": 18, "r": 19, "t": 20, "y": 21, "u": 22, "i": 23, "o": 24, "p": 25,
    "a": 30, "s": 31, "d": 32, "f": 33, "g": 34, "h": 35, "j": 36, "k": 37, "l": 38,
    "z": 44, "x": 45, "c": 46, "v": 47, "b": 48, "n": 49, "m": 50,
    "tab": 15, "enter": 28, "space": 57,
    "shift": 42, "ctrl": 29, "alt": 56,
}

def notify(title, msg):
    try:
        subprocess.run(["notify-send", "-t", "1000", title, msg], check=False)
    except Exception:
        pass

def run_worker(keycode, interval, hold):
    fd = os.open("/dev/uinput", os.O_WRONLY | os.O_NONBLOCK)
    try:
        fcntl.ioctl(fd, UI_SET_EVBIT, EV_KEY)
        fcntl.ioctl(fd, UI_SET_KEYBIT, keycode)
        setup = struct.pack("HHHH80sI", BUS_USB, 0x1234, 0x5678, 1, b"Virtual AutoKey", 0)
        fcntl.ioctl(fd, UI_DEV_SETUP, setup)
        fcntl.ioctl(fd, UI_DEV_CREATE)

        running = [True]
        def handle_sig(sig, frame):
            running[0] = False

        signal.signal(signal.SIGTERM, handle_sig)
        signal.signal(signal.SIGINT, handle_sig)

        ev_down = struct.pack("qqHHi", 0, 0, EV_KEY, keycode, 1)
        ev_up = struct.pack("qqHHi", 0, 0, EV_KEY, keycode, 0)
        ev_syn = struct.pack("qqHHi", 0, 0, EV_SYN, SYN_REPORT, 0)

        rest = max(0.005, interval - hold)
        while running[0]:
            os.write(fd, ev_down + ev_syn)
            time.sleep(hold)
            os.write(fd, ev_up + ev_syn)
            time.sleep(rest)
    finally:
        try:
            ev_up = struct.pack("qqHHi", 0, 0, EV_KEY, keycode, 0)
            ev_syn = struct.pack("qqHHi", 0, 0, EV_SYN, SYN_REPORT, 0)
            os.write(fd, ev_up + ev_syn)
            fcntl.ioctl(fd, UI_DEV_DESTROY)
            os.close(fd)
        except Exception:
            pass

def main():
    if len(sys.argv) > 1 and sys.argv[1] == "--worker":
        keycode = int(sys.argv[2])
        interval = float(sys.argv[3])
        hold = float(sys.argv[4])
        run_worker(keycode, interval, hold)
        return

    key_arg = sys.argv[1].lower() if len(sys.argv) > 1 else "f"
    interval = float(sys.argv[2]) if len(sys.argv) > 2 else 0.05
    hold = float(sys.argv[3]) if len(sys.argv) > 3 else 0.02

    if key_arg.isdigit():
        keycode = int(key_arg)
        key_name = str(keycode)
    else:
        keycode = KEY_MAP.get(key_arg, 33)
        key_name = key_arg.upper()

    pid_dir = os.environ.get("XDG_RUNTIME_DIR", "/tmp")
    pid_file = os.path.join(pid_dir, f"autokey-{keycode}.pid")

    if os.path.exists(pid_file):
        try:
            with open(pid_file, "r") as f:
                pid = int(f.read().strip())
            os.kill(pid, 0)
            os.kill(pid, signal.SIGTERM)
            os.remove(pid_file)
            notify("AutoKey", f"Stopped ({key_name})")
            print(f"Stopped AutoKey for {key_name}")
            return
        except (ProcessLookupError, ValueError):
            if os.path.exists(pid_file):
                os.remove(pid_file)
        except PermissionError:
            pass

    script_path = os.path.abspath(__file__)
    proc = subprocess.Popen(
        [sys.executable, script_path, "--worker", str(keycode), str(interval), str(hold)],
        stdin=subprocess.DEVNULL,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        close_fds=True,
        start_new_session=True,
    )
    with open(pid_file, "w") as f:
        f.write(str(proc.pid))
    speed_label = f"{int(interval * 1000)}ms" if interval < 1 else f"{interval}s"
    notify("AutoKey", f"Started ({key_name} @ {speed_label})")
    print(f"Started AutoKey for {key_name} (PID: {proc.pid})")

if __name__ == "__main__":
    main()
