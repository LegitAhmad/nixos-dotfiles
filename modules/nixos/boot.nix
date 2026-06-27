{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Use the latest stable Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    limine = {
      enable = true;
      # timeout = 10;
    };
    systemd-boot.enable = false;
  };

  boot = {
    initrd.supportedFilesystems = [ "btrfs" ];
    initrd.kernelModules = [ "btrfs" ];
    initrd.compressor = "xz";
    supportedFilesystems = [ "btrfs" ];

    tmp.useTmpfs = true;
    tmp.tmpfsSize = "2G";

    resumeDevice = "/dev/disk/by-label/nixos";
    kernelParams = [ "resume_offset=533760" ];
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 150;
    "vm.page-cluster" = 0;
    "vm.watermark_scale_factor" = 125;
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };
}
