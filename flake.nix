{
  description = "Ubuntu home-manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim_config = {
      url = "github:hayesHowYaDoin/nvim_config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    home-manager,
    nixpkgs,
    stylix,
    ...
  } @ inputs: let
    # Supported systems
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
      overlays = [
        (self: super: {
          nvim = inputs.nvim_config.packages.${super.system}.default;
        })
      ];
    };
  in {
    # Standalone home-manager configuration entrypoints
    # Available through 'home-manager --flake .#username@hostname'
    homeConfigurations = {
      default = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs pkgs;};
        modules = [
          ./home/default.nix
          stylix.homeManagerModules.stylix
        ];
      };
    };
  };
}
