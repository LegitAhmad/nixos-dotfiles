#!/usr/bin/env python3
"""genshin-wish — extract the Genshin wish-history URL from the game cache,
validate it, and/or export the full wish history.

Usage:
  genshin-wish url     extract + validate the authkey URL, copy to clipboard
  genshin-wish fetch   export full history to ~/Documents or a given path
  genshin-wish check   just report which cached authkeys are alive

The game must have opened the Wish > History screen at least once this
session. Cached authkeys keep working for weeks, so old ones may still do.
"""
import json, os, re, subprocess, sys, time, urllib.request, urllib.parse, glob

GAME = os.path.expanduser(
    "~/.local/share/anime-games-launcher/packages/persistent/"
    "4462fca045b4276f-genshin_impact/global_game_files/GenshinImpact_Data/webCaches")
API = "https://public-operation-hk4e-sg.hoyoverse.com/gacha_info/api/getGachaLog"
STORE = os.path.expanduser("~/.local/share/genshin-wish")
BANNERS = {"100": "Beginners' Wish", "200": "Standard", "301": "Character Event", "302": "Weapon Event"}


def cache_files():
    files = glob.glob(f"{GAME}/*/Cache/Cache_Data/data_[12]")
    return sorted(files, key=os.path.getmtime, reverse=True)


def candidate_urls():
    seen, out = set(), []
    for f in cache_files():
        data = open(f, "rb").read()
        for m in re.finditer(rb'https://gs\.hoyoverse\.com/genshin/event/'
                             rb'e20190909gacha[^\x00-\x20"<>]*?game_biz=hk4e_global', data):
            u = m.group().decode()
            key = re.search(r"authkey=([^&]+)", u).group(1)
            if key not in seen:
                seen.add(key)
                out.append(u)
    return out


def validate(url):
    p = dict(urllib.parse.parse_qsl(url.split("?", 1)[1]))
    p.update(gacha_type="301", size="1", page="1", end_id="0")
    try:
        dat = json.loads(urllib.request.urlopen(f"{API}?{urllib.parse.urlencode(p)}", timeout=20).read())
    except Exception as e:
        return False, str(e)
    return dat.get("retcode") == 0, dat.get("message", "")


def live_url():
    for u in candidate_urls():
        ok, msg = validate(u)
        if ok:
            return u
        print(f"  dead key ({msg}), trying next...", file=sys.stderr)
    return None


def save_url(u):
    os.makedirs(STORE, exist_ok=True)
    open(f"{STORE}/url.txt", "w").write(u + "\n")


def clipboard(text):
    for cmd in (["wl-copy"], ["xclip", "-selection", "clipboard"]):
        try:
            subprocess.run(cmd, input=text.encode(), check=True)
            return cmd[0]
        except (FileNotFoundError, subprocess.CalledProcessError):
            continue
    return None


def fetch(out_path):
    url = live_url()
    if not url:
        sys.exit("No working authkey. Open Wish > History in-game, then rerun.")
    save_url(url)
    params = dict(urllib.parse.parse_qsl(url.split("?", 1)[1]))
    params.update(lang="en", size="20")
    rows, uid, total = [], "", 0
    for code, label in BANNERS.items():
        page, last_id, count = 1, 0, 0
        while True:
            p = dict(params, gacha_type=code, page=str(page), end_id=str(last_id))
            dat = json.loads(urllib.request.urlopen(f"{API}?{urllib.parse.urlencode(p)}", timeout=30).read())
            if dat.get("retcode") != 0:
                sys.exit(f"API error: {dat.get('message')}")
            lst = dat["data"]["list"]
            if not lst:
                break
            uid = uid or lst[0]["uid"]
            for w in lst:
                rows.append(f"{w['gacha_type']},{w['time']},{w['name']},{w['item_type']},{w['rank_type']}")
            count += len(lst)
            last_id = lst[-1]["id"]
            page += 1
            time.sleep(0.8)
        total += count
        print(f"{label}: {count} pulls")
    out = "paimonmoe,importer,version,1,0\n" + "\n".join(rows) + "\n"
    open(out_path, "w").write(out)
    print(f"uid {uid}: {total} pulls -> {out_path}")


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else "url"
    if cmd == "fetch":
        fetch(sys.argv[2] if len(sys.argv) > 2 else os.path.expanduser("~/genshin-wishes.csv"))
        return
    urls = candidate_urls()
    if cmd == "check":
        for u in urls:
            ok, msg = validate(u)
            print(("LIVE " if ok else "dead ") + re.search(r"timestamp=(\d+)", u).group(1))
        return
    # url (default): also reuse a previously saved key if still alive
    saved = f"{STORE}/url.txt"
    for u in ([open(saved).read().strip()] if os.path.exists(saved) else []) + urls:
        ok, msg = validate(u)
        if ok:
            save_url(u)
            tool = clipboard(u)
            print(u)
            print(f"authkey OK, URL copied to clipboard{f' ({tool})' if tool else ' (no clipboard tool!)'}")
            return
        print(f"  dead key ({msg}), trying next...", file=sys.stderr)
    sys.exit("No working authkey found. Open Wish > History in-game, then rerun.")


if __name__ == "__main__":
    main()
