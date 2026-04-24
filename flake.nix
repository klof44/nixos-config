{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    DuckGameRebuilt = {
      url = "github:klof44/DuckGameRebuilt-Nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    affinity-nix = {
      url = "github:mrshmllow/affinity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{nixpkgs, home-manager, nix-cachyos-kernel, affinity-nix, ...}: {
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
          # boot.kernelPackages = pkgs.linuxPackages_6_18;  

          nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned affinity-nix.overlays.default ];
          boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

          nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" "https://cache.garnix.io" ];
          nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];

          environment.systemPackages = [ affinity-nix.packages.x86_64-linux.affinity-v3 ];
        })
      ];

      specialArgs = { inherit inputs; };
    };
  };
}
