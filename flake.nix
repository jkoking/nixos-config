{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }@inputs: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
    nixosConfigurations.framework-16 = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/framework-16/configuration.nix
        ./modules/nixos/kde.nix
        inputs.home-manager.nixosModules.default
        nixos-hardware.nixosModules.framework-16-7040-amd

      ];
    };
  };
}
