{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-openclaw.url = "github:openclaw/nix-openclaw";
    #nix-steipete-tools-summarize.url = "github:openclaw/nix-steipete-tools?dir=tools/summarize";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nix-openclaw,
      ...
    }:
    {
      nixosConfigurations = {
        NixNAS = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.py = import ./home.nix;
              home-manager.sharedModules = [
                nix-openclaw.homeManagerModules.openclaw
              ];
            }
          ];
        };
      };
    };
}
