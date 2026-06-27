{ config, lib, ... }:

{
  # Define your hostname.
  networking.hostName = "nixos-btw";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Karachi";

  # Set your locale.
  i18n.defaultLocale = "en_US.UTF-8";
}
