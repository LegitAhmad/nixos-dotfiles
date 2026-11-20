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

  # Mesa 26.3.1 ANV regression: repeated i915 GPU hangs (ecode 12:1, Raptor
  # Lake iGPU) under Vulkan load, reproducible in ~3 minutes of Genshin.
  # Pin mesa to 26.2.6 from the locked nixpkgs-mesa262 input (2026-11-17
  # nixpkgs, all binaries on cache.nixos.org). Applied per host-arch so the
  # 32-bit (i686) package set used by Steam/Proton pins correctly too.
  # Remove together with the nixpkgs-mesa262 flake input once fixed upstream.
  nixpkgs.overlays = [
    (
      final: prev:
      { mesa = inputs.nixpkgs-mesa262.legacyPackages.${prev.stdenv.hostPlatform.system}.mesa; }
    )
  ];

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
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs self repoDir; };
    users.legitahmad = import "${self}/modules/home";
  };
}
