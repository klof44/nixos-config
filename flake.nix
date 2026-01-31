{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    DuckGameRebuilt = {
      url = "github:klof44/DuckGameRebuilt-Nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

  };

  outputs = inputs@{nixpkgs, home-manager, nix-cachyos-kernel, ...}: {
    nixosConfigurations.LEgion = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/LEgion/configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.maxim = {
              imports = [
                ./hosts/LEgion/home.nix
              ];
            };
            extraSpecialArgs = { inherit inputs; };
            backupFileExtension = "backup";
          };
        }

        ({ pkgs, ... }:
        {
          nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ];
          boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

          nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
          nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="  ];
        })
      ];

      specialArgs = { inherit inputs; };
    };

    nixosConfigurations.compaq = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/compaq/configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.maxim = {
              imports = [
                ./hosts/compaq/home.nix
              ];
            };
            extraSpecialArgs = { inherit inputs; };
            backupFileExtension = "backup";
          };
        }
      ];

      specialArgs = { inherit inputs; };
    };
  };
}
