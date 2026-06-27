{ config, lib, pkgs, inputs, ... }:

{
  # Nix settings.
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    accept-flake-config = true;
    narinfo-cache-negative-ttl = 0;
    warn-dirty = false;
    substituters = [
      "https://cache.nixos.org"
      "https://noctalia.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
    trusted-users = [ "root" "@wheel" ];

    # 12-Core CPU & Disk I/O optimizations
    max-jobs = "auto";
    cores = 0;                         # Tells Nix to use all 12 cores for building packages
    auto-optimise-store = true;        # Hardlink identical files in the store to save disk space and I/O time
  };

  # Enable fish shell system-wide.
  programs.fish.enable = true;

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    btrfs-progs
    compsize
  ];

  # Nix Helper (nh) configuration.
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/legitahmad/nixos-dotfiles";
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

            # Swap / and Right Alt (rightalt is mapped to /)
            rightalt = "/";

            # Swap Backspace and Right Shift
            backspace = "rightshift";
            rightshift = "backspace";
          };

          # 2. Re-create the Shift layer behaviour for your Right Alt / Slash swap
          # In a standard layout, 'shift + /' yields '?'. 
          # Because 'rightalt' is now physically acting as your slash key,
          # holding Shift while hitting Right Alt needs to output '?' instead of 'rightalt' mappings.
          shift = {
            rightalt = "?";
          };

          # 3. Create a custom modifier layer to catch what Right Alt does now
          # Since 'rightalt' is now '/', its shifted variant is '?'.
          # Therefore, hitting '/' normally outputs Right Alt.
          # Holding '/' and hitting another key should trigger Alt shortcuts.
          # We turn the '/' key into a layer modifier that mirrors standard 'alt'.
          "/" = {
            "~rightalt" = "M-rightalt"; # Falls back to the system's Right Alt meta modifier
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

  # System state version.
  system.stateVersion = "26.05";
}
