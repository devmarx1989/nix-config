{
  description = "NixOS + WSL + Home Manager + NixVim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    home-manager.url = "github:nix-community/home-manager";
    nixvim.url = "github:nix-community/nixvim";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nixvim, nixos-wsl, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          nixos-wsl.nixosModules.wsl
          ./configuration.nix
          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.devmarx = {
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
