{ config, lib, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./desktop.nix
    ./network.nix
    ./system.nix
    ./users.nix
    ./theme.nix
  ];
}
