{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      nixpkgs,
      nixos-hardware,
      plasma-manager,
      ...
    }:
    {
      nixosConfigurations.framework-16 = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/framework-16/configuration.nix
          ./modules/nixos/kde.nix
          nixos-hardware.nixosModules.framework-16-7040-amd
        ];
      };
      home-manager.nixosModules.home-manager = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
        home-manager.users."jacob" = import ./hosts/framework-16/home.nix;
      };
    };
}
