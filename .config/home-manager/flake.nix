{
  description = "Home Manager configuration of hsteinshiromoto";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
		nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin }@ inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
			homeConfigurations = {
        "hsteinshiromoto" = home-manager.lib.homeManagerConfiguration {
					inherit pkgs;

					# Specify your home configuration modules here, for example,
					# the path to your home.nix.
					modules = [ ./home.nix ];

					# Optionally use extraSpecialArgs
					# to pass through arguments to home.nix
				};
			};
    };
}
