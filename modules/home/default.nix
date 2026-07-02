{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./apps.nix
    ./dev.nix
    ./terminal.nix
    ./fish.nix
    ./nushell.nix
    ./noctalia.nix
    ./neovim.nix
    ./hyprland.nix
    ./zellij.nix
    ./tmux.nix
    ./theme.nix
    ./zsh.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # vesktop pins pnpm_10_29_2 which is marked insecure.
  # Override to use the safe pnpm_10 (10.34.4) instead.
  nixpkgs.overlays = [
    (final: prev: {
      vesktop = prev.vesktop.override { pnpm_10_29_2 = final.pnpm_10; };
    })
  ];

  home.username = "legitahmad";
  home.homeDirectory = lib.mkForce "/home/legitahmad";

  # Compatibility version.
  home.stateVersion = "26.05";
}
