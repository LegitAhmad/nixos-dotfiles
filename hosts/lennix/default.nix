{
  config,
  lib,
  pkgs,
  inputs,
  self,
  repoDir,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    "${self}/modules/nixos"
  ];

  networking.hostName = "lennix";

  home-manager = {
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs self repoDir; };
    users.legitahmad = import "${self}/modules/home";
  };
}
