{
  description = "NixOS + Home Manager + NixVim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra.url = "github:kamadorueda/alejandra";
  };

  outputs = { self, nixpkgs, home-manager, nixvim, alejandra, ... }:
    let
      system   = "x86_64-linux";
      hostname = "house-of-marx";
      user     = "dev-marx";
      myPkgs = {
        inherit alejandra;
      };

      myAttr = builtins.listToAttrs (builtins.map (name: {
        inherit name;
        value = myPkgs.${name}.packages.${system}.default;
      }) (builtins.attrNames myPkgs));
    in {
      ###########################################################################
      ## 2.1 ▸ Stand‑alone packages
      ###########################################################################
      packages.${system} = myAttr;

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
          myPkgs = myAttr;
        };
      };
    };
}
