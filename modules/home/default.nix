{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.stylix.homeModules.stylix
    ./apps.nix
    ./dev.nix
    ./terminal.nix
    ./fish.nix
    ./nushell.nix
    ./noctalia.nix
    ./neovim.nix
    ./niri.nix
    ./zellij.nix
    ./tmux.nix
    ./theme.nix
    ./zsh.nix
  ];

  home.username = "legitahmad";
  home.homeDirectory = lib.mkForce "/home/legitahmad";

  # Compatibility version.
  home.stateVersion = "26.05";
}
