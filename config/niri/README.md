# Niri alternative session

Apply from the repository root:

```sh
sudo nixos-rebuild switch --flake .#nixos-btw
```

Log out and select **Niri** in Ly. Hyprland remains the default and is still
available as its plain, non-UWSM session. Niri uses the upstream `niri-session`
launcher for systemd/D-Bus environment setup, graphical-session lifecycle and
XDG autostart. Do not launch it through UWSM as well.

`config.kdl` is a fresh configuration, not an extension of the previous one.
Home Manager links it out of store, so edits reload live. There are no required
shell-generated includes and no hard-coded monitor names, modes or scales.
Inspect connected displays with `niri msg outputs` before adding output overrides.

## Desktop behavior

- Half-screen columns by default; one-third, half and two-thirds width presets.
- Overflow-aware centering, tabbed columns, rounded corners, subtle shadows and
  Catppuccin Mocha focus colors. These colors belong to this standalone config;
  they do not depend on the optional system Catppuccin switch.
- Efficient native xray blur for transparent Foot, Ghostty and WezTerm surfaces.
  This does not force application transparency. Noctalia requests its own blur
  through the standard background-effect protocol.
- Noctalia starts once from Niri and supplies the bar, wallpaper, launcher,
  clipboard, notifications, session menu, native lock screen and polkit prompts.
  Its shared config also enables the native polkit agent for Hyprland. Existing
  idle timeouts are unchanged; automatic idle locking remains opt-in in Noctalia.
- GNOME Keyring starts with the same SSH-agent and D-Bus environment import used
  by the Hyprland session.
- GNOME screencasting portal, GTK file chooser and existing Thunar file manager.
- No compositor-wide toolkit/backend environment overrides or separate
  notification, clipboard or idle daemon.

## Shared Noctalia appearance

`config/noctalia/config.toml` is shared with Hyprland and reloads live:

- Edge-to-edge Catppuccin bar flush with the top and both sides, with a centered
  date/time and focus-hint workspaces. Media titles stay bounded to 180 pixels;
  the media widget and spectrum disappear when nothing is playing.
- Subtle capsule groups organize connectivity, volume/brightness, and
  power-profile/battery/caffeine controls. Bluetooth stays visible even when off
  or disconnected: left-click opens controls; right-click toggles adapter power.
  Device details remain in hover tooltips instead of widening the bar.
- Scroll volume or brightness for 5-percentage-point adjustments; right-click
  volume to mute. Brightness hides on outputs without a controllable backlight.
  Wallpaper/session actions remain in Control Center; keyboard shortcuts are
  unchanged.
- Power-profile control uses the existing TuneD interface (balanced,
  performance, power-saver), with distinct glyphs and theme colors. Left-click
  cycles forward; right-click cycles backward.
- The coffee icon toggles compositor idle inhibition and gets an accent-filled
  background while active. Adding the widget does not enable caffeine.
- Compact search-first launcher and most-recently-used window switcher.
- Floating soft-translucent panels, shorter fade transitions, at most three
  compact 320-pixel notification toasts on the focused display, and bottom-center
  volume/brightness OSDs. Critical alerts retain the stronger urgency border and
  sender-requested persistence rather than receiving a blanket timeout.
- Low-battery warnings start at 20%; native critical escalation at 5% and 2%
  remains enabled, including its existing DND bypass for the system battery.
- Clipboard history remains enabled, but Noctalia no longer preserves the last
  selection after its source application exits, to avoid extending a password
  manager's clipboard lifetime.

GUI changes in `~/.local/state/noctalia/settings.toml` override the dotfiles.
Inspect `noctalia config export merged` if a setting appears not to apply; do not
delete the whole state directory, which also contains unrelated shell data.

### No keyring prompts

Noctalia uses `[storage].key_source = "file"` instead of Secret Service.
Home Manager generates `~/.local/state/noctalia/storage-key` once with mode
`0600`; it is never embedded in the Nix store or committed to the repository.
Keep this key stable and private. Anyone with a copy of both the key and stored
history can decrypt that history; this is not password-protected keyring storage.

Existing keyrings and older encrypted history are not deleted or migrated.
History encrypted with the old key may be unavailable with the new file key.
Do not use **Recover Private Storage** unless you intend to erase old history.
Calendar accounts that require Secret Service remain opt-in; none are configured
here.

### Bitwarden

Home Manager installs the pinned native
[official Bitwarden plugin](https://github.com/noctalia-dev/official-plugins/tree/734850fd1ee3badc2a18a515df31f36267852e46/bitwarden)
and its CLI dependencies, with matching sensitive-copy patches for the plugin
and shell. Apply the Nix changes with the rebuild command above, then log out
and back in so the compositor starts the patched shell. Config reload alone
cannot load native code changes. The plugin refuses secret copies on an older
shell and asks you to install/restart the matching shell rather than silently
falling back to unsafe copying.

Click the bar's lock icon or open the launcher and type `/bw`. Log in through
the plugin's **Log in** panel or run `bw login` interactively, then unlock in the
plugin. For EU or self-hosted accounts, configure **Server URL** before login
(or use `bw config server https://your.server`). Never put credentials in these
dotfiles or pass passwords/API secrets as command-line arguments.

The vault auto-locks after 15 minutes of inactivity. Vault-field, generated
password, and generated passphrase copies advertise the password-manager
sensitive hint while remaining pasteable as normal text. Noctalia excludes
these selections from clipboard history and orphan adoption; ordinary copies
still retain history. Other clipboard managers must honor the hint themselves.
Copies are cleared after 30 seconds only if Noctalia still owns the same
selection, so the timer never erases a newer copy. Copy failures report an error
instead of falling back to an ordinary, history-retained copy. Existing saved
history is not purged.

The plugin runs `bw serve` on `127.0.0.1:8087`. While unlocked, other local
processes that can reach that port can read vault secrets. Use `/bw` → **Lock
vault** or **Log out** when finished; `bw logout` alone does not invalidate a
running unlocked server. The plugin source is Nix-pinned; update its revision
and hash in `modules/home/noctalia.nix` to upgrade it.

The native widget-state and clipboard patches live in
`modules/home/noctalia/`. The package build runs the `clipboard_service` and
`plugin_lifecycle` regressions using synthetic data, without the user clipboard
or a keyring. Keep the source pins and patches compatible when updating;
native patch changes require rebuilding the shell.

## Essential keys

`Super` is `Mod` in a normal session; nested Niri uses `Alt` instead.

| Keys | Action |
| --- | --- |
| Super+T / B / E | Foot / Helium / Thunar |
| Super+A / V / W / N | Launcher / clipboard / wallpaper / notifications |
| Super+, / Delete | Noctalia settings / session menu |
| Super+Alt+P / C | Color picker / toggle PC sharing |
| Super+Alt+L | Lock screen |
| Super+H/J/K/L or arrows | Focus columns and windows |
| Super+Ctrl+H/J/K/L | Move columns and windows |
| Super+Shift+H/L or J/K | Resize width or height |
| Super+R / Shift+R | Cycle column width / window height |
| Super+F / Shift+F | Maximize column / fullscreen window |
| Super+Space / Shift+Space | Toggle floating / focus floating versus tiling |
| Super+[ / ] | Merge into or split out of a neighboring column |
| Super+Ctrl+T | Toggle tabbed column display |
| Super+O | Workspace overview |
| Super+1…9 / Shift+1…9 | Focus workspace / move column to workspace |
| Super+Alt+1…9 | Move column to workspace without following |
| Super+PageUp/PageDown | Previous/next workspace |
| Super+Tab | Previous workspace |
| Super+Shift+N/O | Next / toggle media playback |
| Print / Super+Print / Super+Shift+Print | Region / screen / window screenshot |
| Super+Escape | Escape shortcut inhibition (remote desktop/KVM) |
| Super+Shift+E | Log out with confirmation |
| Super+Shift+P | Power displays off; input wakes them |
| Super+Shift+/ (Super+?) | Show the hotkey overlay |

Screenshots also go to `~/Pictures/Screenshots`. Audio, media and backlight keys
work while locked. Other bindings are listed directly in `config.kdl`.

## Version and updates

Niri comes from the pinned nixpkgs `niri` package, which is available from the
configured binary caches. It follows the repository's nixpkgs channel rather
than building the upstream Niri source flake locally.

To update Niri with nixpkgs:

```sh
nix flake update nixpkgs
sudo nixos-rebuild switch --flake .#nixos-btw
```


The fresh config does not depend on the previous configuration or any
shell-generated KDL includes.

## Checks

```sh
niri validate --config config/niri/config.kdl
noctalia config validate config/noctalia/config.toml
nix eval .#nixosConfigurations.nixos-btw.config.system.build.toplevel.drvPath
```

A nested compositor is useful for previewing without logging out:

```sh
niri --config config/niri/config.kdl
```

Do **not** add `--session` when nesting: it would replace the main desktop's
systemd/D-Bus environment. For a second Noctalia instance, also isolate its
runtime directory, D-Bus session and config/state; otherwise its single-instance
IPC can target the main desktop. A nested preview does not prove physical display
modes, a Ly login, PAM unlock or portal screen sharing on the real session.
