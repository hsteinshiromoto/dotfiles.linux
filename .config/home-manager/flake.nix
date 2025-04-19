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

  outputs = { self, nixpkgs, home-manager, nix-darwin, ...} @ inputs:
    let
			inherit (self) outputs;
      # Supported systems for your flake packages, shell, etc.
			systems = [
				"aarch64-linux"
				"i686-linux"
				"x86_64-linux"
				"aarch64-darwin"
				"x86_64-darwin"
			];
			# This is a function that generates an attribute by calling a function you
			# pass to it, with each system as an argument
			forAllSystems = nixpkgs.lib.genAttrs systems;
		in {
			# Your custom packages
			# Accessible through 'nix build', 'nix shell', etc
			# packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
			# Formatter for your nix files, available through 'nix fmt'
			# Other options beside 'alejandra' include 'nixpkgs-fmt'
			formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

			# Your custom packages and modifications, exported as overlays
			# overlays = import ./overlays {inherit inputs;};

			# Reusable nixos modules you might want to export
			# These are usually stuff you would upstream into nixpkgs
			# nixosModules = import ./modules/nixos;

			# Reusable home-manager modules you might want to export
			# These are usually stuff you would upstream into home-manager
			# homeManagerModules = import ./modules/home-manager;

			# NixOS configuration entrypoint
			# Available through 'nixos-rebuild --flake .#your-hostname'
			nixosConfigurations = {
				servidor = nixpkgs.lib.nixosSystem {
					specialArgs = {inherit inputs outputs;};
					# modules = [
					# 	# > Our main nixos configuration file <
					# 	./nixos/configuration.nix
					# ];
				};
			};

			# Standalone home-manager configuration entrypoint
			# Available through 'home-manager --flake .#your-username@your-hostname'
			homeConfigurations = {
        "hsteinshiromoto@servidor" = home-manager.lib.homeManagerConfiguration {
					pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
					extraSpecialArgs = {inherit inputs outputs;};

					# Specify your home configuration modules here, for example,
					# the path to your home.nix.
					modules = [ ./home.nix ];

					# Optionally use extraSpecialArgs
					# to pass through arguments to home.nix
				};
			};
    };
}
# ---
# References:
# ---
#   [1] https://github.com/Misterio77/nix-starter-configs/tree/main
#   [2] https://github.com/omerxx/dotfiles/blob/master/nix-darwin/flake.nix
