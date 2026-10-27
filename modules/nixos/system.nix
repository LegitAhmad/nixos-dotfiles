{
  config,
  lib,
  pkgs,
  inputs,
  repoDir,
  ...
}:

{
  # Nix settings.
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    accept-flake-config = true;
    warn-dirty = false;
    substituters = [
      "https://cache.nixos.org"
      "https://noctalia.cachix.org"
      "https://cache.numtide.com"
      "https://nix-community.cachix.org"
      "https://ezkea.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];

    # 12-Core CPU & Disk I/O optimizations
    max-jobs = "auto";
    cores = 0; # Tells Nix to use all 12 cores for building packages
    auto-optimise-store = true; # Hardlink identical files in the store to save disk space and I/O time

    # Parallelize substituter lookups & downloads.
    max-substitution-jobs = 32;
    http-connections = 50;

  };

  # Pin the global nixpkgs registry to the flake input so nix search/shell
  # doesn't re-download the nixpkgs tarball from the network.
  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  # Enable fish and zsh shells system-wide.
  programs.fish.enable = true;
  programs.zsh.enable = true;
  environment.shells = with pkgs; [
    nushell
    zsh
  ];

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    devenv # Reproducible development shells, pinned by flake.lock.
    btrfs-progs
    compsize
    pciutils # lspci
    usbutils # lsusb
    smartmontools # disk health (smartctl)
    gparted # partition editor
  ];

  # Enable firmware updates and provide fwupdmgr.
  services.fwupd.enable = true;

  # Nix Helper (nh) configuration.
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = repoDir;
  };

  # Keyd remapping service
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          # 1. Main layer changes
          main = {
            # Swap CapsLock and Escape
            capslock = "esc";
            esc = "capslock";

            # Swap / and Right Alt (AltGr)
            slash = "layer(altgr)";
            rightalt = "slash";
            altgr = "slash";

            # Swap Backspace and Right Shift
            backspace = "rightshift";
            rightshift = "backspace";

            # Swap Up/Down arrows with PgUp/PgDown
            up = "pageup";
            pageup = "up";
            down = "pagedown";
            pagedown = "down";
          };

          # 2. Shift layer: produce '?' when holding Shift with Right Alt / AltGr
          shift = {
            rightalt = "?";
            altgr = "?";
          };
        };
      };
    };
  };

  # Configure systemd timeouts for stopping services to be 10 seconds (modern NixOS syntax)
  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "10s";
  };
  systemd.user.settings.Manager = {
    DefaultTimeoutStopSec = "10s";
  };

  # Configure systemd suspend to prefer deep sleep (S3) over s2idle
  systemd.sleep.settings.Sleep = {
    MemorySleepMode = "deep s2idle";
  };

  # System state version.
  system.stateVersion = "26.05";
}
