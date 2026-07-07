{ withSystem, ... }: {
	flake.nixosModules.nix = { config, ... }: {
		nixpkgs.pkgs = withSystem config.nixpkgs.hostPlatform.system ({ pkgs, ... }: pkgs);

		nix.settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ];
	};
}
