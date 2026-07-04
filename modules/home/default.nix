{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./apps.nix
    ./dev.nix
    ./terminal.nix
    ./shell-shared.nix
    ./fish.nix
    ./nushell.nix
    ./noctalia.nix
    ./neovim.nix
    ./hyprland.nix
    ./zellij.nix
    ./tmux.nix
    ./theme.nix
    ./zsh.nix
    ./vscode.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.username = "legitahmad";
  home.homeDirectory = lib.mkForce "/home/${config.home.username}";

  # Compatibility version.
  home.stateVersion = "26.05";
}
