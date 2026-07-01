{
  description = "I use NixOS btw";

  nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://catppuccin.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
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

    catppuccin.url = "github:catppuccin/nix";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jjsigns = {
      url = "github:evanphx/jjsigns.nvim";
      flake = false;
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
      mnw,
      catppuccin,
      ...
    }@inputs:
    {
      nixosConfigurations."nixos-btw" = nixpkgs.lib.nixosSystem {
        system = "x86_64_linux";

        specialArgs = { inherit inputs; };

        modules = [
          ./hosts/nixos-btw

          home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.catppuccin.nixosModules.catppuccin
        ];
      };
    };
}
