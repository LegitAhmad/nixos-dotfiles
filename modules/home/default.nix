{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./apps.nix
    ./dev.nix
    ./terminal.nix
    ./fish.nix
    ./nushell.nix
    ./noctalia.nix
    ./lazyvim.nix
    ./niri.nix
    ./zellij.nix
    ./tmux.nix
    ./theme.nix
  ];

  home.username = "legitahmad";
  home.homeDirectory = lib.mkForce "/home/legitahmad";

  # Compatibility version.
  home.stateVersion = "26.05";
}
