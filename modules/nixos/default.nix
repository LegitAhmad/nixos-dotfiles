{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./boot.nix
    ./desktop.nix
    ./docker.nix
    ./network.nix
    ./system.nix
    ./users.nix
    ./theme.nix
  ];
}
