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
  };

  outputs = inputs@{nixpkgs, home-manager, ...}: {
    nixosConfigurations.LEgion = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/LEgion/configuration.nix
        home-manager.nixosModules.home-manager
	{
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

	./modules/nixos/nvidia.nix
      ];

      specialArgs = { inherit inputs; };
    };
  };
}
