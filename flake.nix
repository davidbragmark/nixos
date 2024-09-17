{
  description = "David's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix = {
      url = "github:danth/stylix/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    stylix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    neovim = inputs.neovim-nightly-overlay.overlay;
    unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };
    specialArgs = {
      # use unstable branch for some packages to get the latest updates
      # pkgs-unstable = import nixpkgs-unstable {
      #   inherit system;
      #   config.allowUnfree = true;
      # };
      inherit inputs;
      inherit system;
    };
    overlays = [
      unstable
      #neovim
    ];
  in {
    # Custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit specialArgs;

        modules = [
          # Overlays-module makes "pkgs.unstable" available in configuration.nix
          ({
            config,
            pkgs,
            ...
          }: {nixpkgs.overlays = overlays;})
          stylix.nixosModules.stylix
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = specialArgs;
              users.david = import ./home;
            };
          }
        ];
      };
    };
  };
}
