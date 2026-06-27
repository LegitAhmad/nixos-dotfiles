{
  description = "I use NixOS btw";

  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    noctalia.url = "github:noctalia-dev/noctalia";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lazyvim = {
      url = "github:pfassina/lazyvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, lazyvim, ... }@inputs: {
    nixosConfigurations."nixos-btw" = nixpkgs.lib.nixosSystem {
      system = "x86_64_linux";

      specialArgs = { inherit inputs; };

      modules = [
        ./hosts/nixos-btw

        home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
      ];
    };
  };
}
