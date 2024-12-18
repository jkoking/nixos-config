{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.framework-16 = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/framework-16/configuration.nix
          ./modules/nixos/kde.nix
          nixos-hardware.nixosModules.framework-16-7040-amd
        ];
      };
      homeConfigurations.jacob = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./hosts/framework-16/home.nix ];
      };
    };
}
