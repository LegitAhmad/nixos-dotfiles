{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./apps.nix
    ./dev.nix
    ./terminal.nix
    ./fish.nix
    ./noctalia.nix
    ./lazyvim.nix
    ./niri.nix
    ./zellij.nix
    ./tmux.nix
    ./theme.nix
  ];

  home.username = "LegitAhmad";
  home.homeDirectory = lib.mkForce "/home/LegitAhmad";

  # Compatibility version.
  home.stateVersion = "26.05";
}
