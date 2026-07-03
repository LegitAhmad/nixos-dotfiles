{ config, lib, pkgs, inputs, self, ... }:

{
  imports = [
    ./hardware-configuration.nix
    "${self}/modules/nixos"
  ];

  boot = {
    resumeDevice = "/dev/disk/by-label/nixos";
    kernelParams = [ "resume_offset=533760" ];
  };

  home-manager = {
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs self; };
    users.legitahmad = import "${self}/modules/home";
  };
}
