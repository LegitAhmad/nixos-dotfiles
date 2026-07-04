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
    initrd.kernelModules = [
      "btrfs"
      "i915"
    ];
    initrd.compressor = "xz";
    supportedFilesystems = [ "btrfs" ];

    tmp.useTmpfs = true;
    tmp.tmpfsSize = "2G";

    plymouth.enable = true;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
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
