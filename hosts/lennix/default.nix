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

  # MonsGeek / Akko keyboard WebHID and raw HID access (VID 3151).
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="3151", MODE="0666", TAG+="uaccess"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3151", MODE="0666", TAG+="uaccess"
  '';

  home-manager = {
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs self repoDir; };
    users.legitahmad = import "${self}/modules/home";
  };
}
