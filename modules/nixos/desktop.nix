{ config, lib, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  # Enable touchpad support.
  services.libinput.enable = true;

  # Enable sound with Pipewire.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable the Niri window manager.
  programs.niri.enable = true;

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
  services.gvfs.enable = true;    # Mount, trash, and other file system features
  services.tumbler.enable = true;  # Thumbnail support for images
  programs.xfconf.enable = true;   # Thunar preference savings

  # Enable ly display manager.
  services.displayManager = {
    ly.enable = true;
  };

  # Enable Bluetooth.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Enable power-profiles-daemon for power profile management.
  services.power-profiles-daemon.enable = true;

  # Enable Upower for battery/power management.
  services.upower.enable = true;

  # Enable Polkit for privilege management.
  security.polkit.enable = true;

  # Fonts configuration
  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "FantasqueSansM Nerd Font" ];
      };
    };
  };
}
