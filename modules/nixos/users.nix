{ config, lib, pkgs, ... }:

{
  # Define a user account.
  users.users.LegitAhmad = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ]; # Enable ‘sudo’, NetworkManager, and brightness/video control.
    initialPassword = "changeme";
    shell = pkgs.fish;
  };
}
