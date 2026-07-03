{
  description = "I use NixOS btw";

  nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://catppuccin.cachix.org"
      "https://numtide.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    noctalia.url = "github:noctalia-dev/noctalia";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mnw = {
      url = "github:Gerg-L/mnw";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

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
      mnw,
      catppuccin,
      llm-agents,
      ...
    }@inputs:
    {
      nixosConfigurations."nixos-btw" = nixpkgs.lib.nixosSystem {
        system = "x86_64_linux";

        specialArgs = { inherit inputs self; };

        modules = [
          ./hosts/nixos-btw

          home-manager.nixosModules.home-manager
          inputs.catppuccin.nixosModules.catppuccin
        ];
      };
    };
}
