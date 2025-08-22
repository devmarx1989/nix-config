{
  description = "NixOS + Home Manager + NixVim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra.url = "github:kamadorueda/alejandra";
    mathematica-flake.url = "github:devmarx1989/mathematica-flake";
    doxx.url = "github:bgreenwell/doxx";
    #lstr.url = "github:bgreenwell/lstr";
    emacs-ng.url = "github:emacs-ng/emacs-ng";
    #z-lib.url = "github:devmarx1989/z-lib-deb-nix";
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixvim,
    disko,
    alejandra,
    mathematica-flake,
    doxx,
    #lstr,
    emacs-ng,
    #z-lib,
    ...
  }: let
    system = "x86_64-linux";
    hostname = "house-of-marx";
    user = "dev-marx";
    myPkgs = {
      inherit alejandra mathematica-flake doxx emacs-ng;
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
        disko.nixosModules.disko
        ./modules/options/ports.nix
        ./system/default.nix
        home-manager.nixosModules.home-manager
        ({config, ...}: {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              myPkgs = myAttr;
              ports = config.my.ports;
            };

            users.${user} = {
              imports = [
                nixvim.homeManagerModules.nixvim
                ./home/default.nix
              ];
            };
          };
        })
      ];

      specialArgs = {
        inherit home-manager nixvim;
      };
    };
  };
}
