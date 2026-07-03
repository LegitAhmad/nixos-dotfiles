{ config, lib, pkgs, inputs, self, ... }:

{
  imports = [
    ./hardware-configuration.nix
    "${self}/modules/nixos"
  ];

  home-manager = {
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs self; };
    users.legitahmad = import "${self}/modules/home";
  };
}
