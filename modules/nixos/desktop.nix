{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  # Enable touchpad support.
  services.libinput.enable = true;

  # Enable Intel CPU/GPU drivers & hardware graphics acceleration
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      vpl-gpu-rt
    ];
  };

  # Intel CPU temperature/throttling daemon
  services.thermald.enable = true;

  # Enable sound with Pipewire.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable the Hyprland window manager.
  programs.hyprland = {
    enable = true;
    withUWSM = false;
  };

  # Only ship the plain Hyprland desktop file, exclude hyprland-uwsm.desktop.
  services.displayManager.sessionPackages = [
    (pkgs.runCommand "hyprland-sessions-only" {
      providedSessions = [ "hyprland" ];
    } ''
      mkdir -p $out/share/wayland-sessions
      cp ${pkgs.hyprland}/share/wayland-sessions/hyprland.desktop $out/share/wayland-sessions/
    '')
  ];

  # Enable dconf for system-wide configuration storage
  programs.dconf.enable = true;

  # Enable XDG Desktop Portals
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # Enable Thunar file manager and XFCE desktop integrations
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  services.gvfs.enable = true; # Mount, trash, and other file system features
  services.tumbler.enable = true; # Thumbnail support for images
  programs.xfconf.enable = true; # Thunar preference savings

  # Enable ly display manager.
  services.displayManager = {
    ly.enable = true;
  };

  # Delay display manager restart to allow systemd shutdown to cleanly stop the service before it respawns.
  systemd.services.display-manager.serviceConfig = {
    RestartSec = lib.mkForce "3s";
  };

  # Enable Bluetooth.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Enable tuned for power profile management (replaces power-profiles-daemon).
  services.tuned.enable = true;
  # Enable Upower for battery/power management.
  services.upower.enable = true;

  # Enable Polkit for privilege management.
  security.polkit.enable = true;

  # Fonts configuration
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      noto-fonts-color-emoji
      roboto
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" "FiraCode Nerd Font" "Symbols Nerd Font" ];
        sansSerif = [ "Roboto" ];
        serif = [ "Roboto" ];
        emoji = [ "Noto Color Emoji" ];
      };
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <alias>
            <family>JetBrainsMono Nerd Font</family>
            <prefer>
              <family>FiraCode Nerd Font</family>
              <family>Symbols Nerd Font</family>
              <family>Noto Color Emoji</family>
            </prefer>
          </alias>
          <alias>
            <family>JetBrainsMono NF</family>
            <prefer>
              <family>FiraCode Nerd Font</family>
              <family>Symbols Nerd Font</family>
              <family>Noto Color Emoji</family>
            </prefer>
          </alias>
          <alias>
            <family>FiraCode Nerd Font</family>
            <prefer>
              <family>Symbols Nerd Font</family>
              <family>Noto Color Emoji</family>
            </prefer>
          </alias>
          <alias>
            <family>monospace</family>
            <prefer>
              <family>JetBrainsMono Nerd Font</family>
              <family>JetBrainsMono NF</family>
              <family>FiraCode Nerd Font</family>
              <family>Symbols Nerd Font</family>
              <family>Noto Color Emoji</family>
            </prefer>
          </alias>
          <match target="pattern">
            <test name="family" compare="eq">
              <string>emoji</string>
            </test>
            <edit name="family" mode="prepend" binding="strong">
              <string>Noto Color Emoji</string>
            </edit>
          </match>
        </fontconfig>
      '';
    };
  };
}
