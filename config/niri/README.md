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

## Essential keys

`Super` is `Mod` in a normal session; nested Niri uses `Alt` instead.

| Keys | Action |
| --- | --- |
| Super+T / B / E | Foot / Helium / Thunar |
| Super+A / V / W / N | Launcher / clipboard / wallpaper / notifications |
| Super+, / Delete | Noctalia settings / session menu |
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
| Super+PageUp/PageDown | Previous/next workspace |
| Super+Tab | Previous workspace |
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
