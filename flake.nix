{
  description = "NixOS + Home Manager + NixVim";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = { self, nixpkgs, home-manager, nixvim, ... }:
    let
      system   = "x86_64-linux";
      hostname = "house-of-marx";
      user     = "dev-marx";
    in {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./system/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.${user} = {
              imports = [
                nixvim.homeManagerModules.nixvim
                ./home/default.nix
              ];
            };
          }
        ];

        specialArgs = {
          inherit home-manager nixvim;
        };
      };
    };
}
