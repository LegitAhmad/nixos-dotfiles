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

  # Fix stuck/repeating volume keys on Lenovo ThinkBook 14 G6 IRL by forcing key release events.
  services.udev.extraHwdb = ''
    evdev:atkbd:dmi:bvn*:bvr*:svnLENOVO:pn21KG*:pvrThinkBook14G6IRL:*
    evdev:atkbd:dmi:bvn*:bvr*:bd*:svnLENOVO:pn21KG*:pvr*
     KEYBOARD_KEY_a0=!mute
     KEYBOARD_KEY_ae=!volumedown
     KEYBOARD_KEY_b0=!volumeup
  '';

  home-manager = {
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs self repoDir; };
    users.legitahmad = import "${self}/modules/home";
  };
}
