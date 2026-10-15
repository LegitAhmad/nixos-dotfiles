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
      # Keep its pinned nixpkgs to match Numtide's pre-built packages.
    };

    omp = {
      url = "git+ssh://git@github.com/can1357/oh-my-pi?ref=main&shallow=1";
      # Keep upstream's pinned dependencies to match its binary cache.
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
