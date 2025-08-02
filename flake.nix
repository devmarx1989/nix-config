{
  description = "NixOS + WSL + Home Manager + NixVim";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = { self, nixpkgs, home-manager, nixvim, nixos-wsl, ... }:
    let
      system = "x86_64-linux";
      hostname = "houseofmarx";
    in {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          nixos-wsl.nixosModules.wsl
          ./system/default.nix
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
