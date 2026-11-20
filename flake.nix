{
  description = "I use NixOS btw";

  nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://catppuccin.cachix.org"
      "https://cache.numtide.com"
      "https://nix-community.cachix.org"
      "https://ezkea.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Pinned Mesa 26.2.6 for lennix: Mesa 26.3.1 ANV causes repeated i915 GPU
    # hangs (ecode 12:1) on Raptor Lake under Vulkan load. Remove this input
    # and the overlay in hosts/lennix once a fixed mesa lands in unstable.
    nixpkgs-mesa262.url = "github:nixos/nixpkgs/177d0540942fb205af6993b1d5fa0b57799e09f8";

    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
      # Retain upstream's nixpkgs pin and cachix branch to match the official binary cache.
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      # NVF manages Neovim and retains its own transitive mnw dependency.
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    serena = {
      url = "github:oraios/serena";
      # Retain upstream's Python and packaging dependency pins.
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Craft apps not packaged in nixpkgs (and no upstream binary cache):
    # lock official release metadata and fetch upstream's prebuilt binaries.
    # `nix flake update <name>-release` refreshes versions and archive
    # checksums. API counters can change metadata hashes without changing app
    # versions; if several drift, refresh all *-release inputs in one update
    # command. Preserve inputs with `nix flake archive` for historical/cold
    # rebuilds: GitHub's mutable endpoint cannot re-serve a previous JSON
    # snapshot.
    effectcraft-release = {
      url = "file+https://api.github.com/repos/storytold/effectcraft/releases/latest";
      flake = false;
    };
    designcraft-release = {
      url = "file+https://api.github.com/repos/storytold/designcraft/releases/latest";
      flake = false;
    };
    figcraft-release = {
      url = "file+https://api.github.com/repos/storytold/figcraft/releases/latest";
      flake = false;
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sudo-nvim = {
      url = "github:denialofsandwich/sudo.nvim";
      flake = false;
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      catppuccin,
      ...
    }@inputs:
    let
      # Path to the working repo on disk, used for out-of-store symlinks and
      # hot-reloadable configs.
      repoDir = "/home/legitahmad/nixos-dotfiles";
    in
    {
      nixosConfigurations."nixos-btw" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs self repoDir; };

        modules = [
          ./hosts/nixos-btw

          home-manager.nixosModules.home-manager
          inputs.catppuccin.nixosModules.catppuccin
          inputs.aagl.nixosModules.default
        ];
      };

      nixosConfigurations."lennix" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs self repoDir; };

        modules = [
          ./hosts/lennix

          home-manager.nixosModules.home-manager
          inputs.catppuccin.nixosModules.catppuccin
          inputs.aagl.nixosModules.default
        ];
      };

      # `nix fmt` entry point (nixfmt formats RFC 115 style).
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
    };
}
