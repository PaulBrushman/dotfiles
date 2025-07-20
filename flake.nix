{
  description = "System flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixpkgs-25.05-darwin";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs = { nixpkgs, nixpkgs-stable, home-manager, nix-flatpak, ... } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { 
        inherit inputs; 
        pkgs-stable = import nixpkgs-stable {system = "x86_64-linux";config.allowUnfree = true;}; 
      };
      modules = [
        nix-flatpak.nixosModules.nix-flatpak
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; pkgs-stable = import nixpkgs-stable { system = "x86_64-linux";config.allowUnfree = true; }; };
        }
      ];
    };
    homeConfigurations.bob = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit inputs; pkgs-stable = import nixpkgs-stable { system = "x86_64-linux";config.allowUnfree = true; }; };
      };
  };
}
