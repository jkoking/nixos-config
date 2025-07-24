{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
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
      ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs =
    {
      nixpkgs,
      nixos-hardware,
      home-manager,
      plasma-manager,
      ghostty,
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
          extraSpecialArgs = { inherit ghostty; };
        modules = [
          plasma-manager.homeManagerModules.plasma-manager
          ./hosts/framework-16/home.nix
          ./modules/home-manager/ghostty.nix
          ];
      };
    };
}
