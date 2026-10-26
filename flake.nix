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
    };

    affinity-nix = {
      url = "github:mrshmllow/affinity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sls-steam = {
      url = "github:AceSLS/SLSsteam";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    creamlinux-installer = {
      type = "github";
      owner = "Novattz";
      repo = "creamlinux-installer";
      flake = false;
    };
  };

  outputs = inputs@{nixpkgs, home-manager, nix-cachyos-kernel, affinity-nix, sls-steam, creamlinux-installer, ...}: {
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
          # boot.kernelPackages = pkgs.linuxPackages_latest;  

          nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned affinity-nix.overlays.default ];
          environment.systemPackages = [ pkgs.affinity-v3 (import inputs.creamlinux-installer { inherit pkgs; }) ];
          boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;

          nix.settings.substituters = [ "https://cache.lantian.pub/lantian" "https://cache.nixos-cuda.org" ];
          nix.settings.trusted-public-keys = [ "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ=" "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
        })
      ];

      specialArgs = { inherit inputs; };
    };
  };
}
