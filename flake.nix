{
  description = "Ubuntu home-manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim_config = {
      url = "github:hayesHowYaDoin/nvim_config";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    home-manager,
    nix-colors,
    nixgl,
    nixpkgs,
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

          # Override workspace-matrix to use v50 for GNOME Shell 46 compatibility
          gnomeExtensions = super.gnomeExtensions // {
            workspace-matrix = super.gnomeExtensions.workspace-matrix.overrideAttrs (oldAttrs: rec {
              version = "50";
              src = super.fetchzip {
                url = "https://extensions.gnome.org/extension-data/wsmatrixmartin.zurowietz.de.v${version}.shell-extension.zip";
                sha256 = "gKOYq8CmrScOaz5b14pYFJCq/Prln2Evw5tjJ7jTJ8s=";
                stripRoot = false;
              };
            });
          };
        })
      ];
    };
  in {
    homeConfigurations = {
      default = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs pkgs;};
        modules = [
          ./home/default.nix
          nix-colors.homeManagerModules.default
        ];
      };
    };
  };
}
