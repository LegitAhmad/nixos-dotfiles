{
  description = "I use NixOS btw";

  nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://catppuccin.cachix.org"
      "https://cache.numtide.com"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
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

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      # Keep its pinned nixpkgs for Numtide's pre-built agent CLIs, including omp.
    };

    serena = {
      url = "github:oraios/serena";
      # Retain upstream's Python and packaging dependency pins.
    };

    # Lock official release metadata; `nix flake update` refreshes the suite.
    # The package builder selects each Linux archive and its published checksum.
    # Single app: `nix flake update photocraft-release`.
    # API counters can change metadata hashes without changing app versions.
    # Preserve inputs with `nix flake archive` for historical/cold rebuilds:
    # GitHub's mutable endpoint cannot re-serve a previous JSON snapshot.
    photocraft-release = {
      url = "file+https://api.github.com/repos/storytold/photocraft/releases/latest";
      flake = false;
    };
    vectorcraft-release = {
      url = "file+https://api.github.com/repos/storytold/vectorcraft/releases/latest";
      flake = false;
    };
    filmcraft-release = {
      url = "file+https://api.github.com/repos/storytold/filmcraft/releases/latest";
      flake = false;
    };
    lightcraft-release = {
      url = "file+https://api.github.com/repos/storytold/lightcraft/releases/latest";
      flake = false;
    };
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
    soundcraft-release = {
      url = "file+https://api.github.com/repos/storytold/soundcraft/releases/latest";
      flake = false;
    };
    wordcraft-release = {
      url = "file+https://api.github.com/repos/storytold/wordcraft/releases/latest";
      flake = false;
    };
    pdfcraft-release = {
      url = "file+https://api.github.com/repos/storytold/pdfcraft/releases/latest";
      flake = false;
    };
    deckcraft-release = {
      url = "file+https://api.github.com/repos/storytold/deckcraft/releases/latest";
      flake = false;
    };
    cadcraft-release = {
      url = "file+https://api.github.com/repos/storytold/cadcraft/releases/latest";
      flake = false;
    };
    gridcraft-release = {
      url = "file+https://api.github.com/repos/storytold/gridcraft/releases/latest";
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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      catppuccin,
      llm-agents,
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
        ];
      };
    };
}
