{
	inputs = {
		flake-parts.url = "github:hercules-ci/flake-parts";
		import-tree.url = "github:vic/import-tree";

		nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

		impermanence.url = "github:nix-community/impermanence";
		impermanence.inputs.home-manager.follows = "";
	};

	outputs = { ... }@inputs: inputs.flake-parts.lib.mkFlake
		{ inherit inputs; }
		{
			systems = [ "x86_64-linux" ];
			
			imports = [
				({ inputs, ... }: {
					perSystem = { system, ... }: {
						_module.args.pkgs = import inputs.nixpkgs {
							inherit system;
							config.allowUnfree = true;
						};
					};
				})

				(inputs.import-tree ./modules)
			];
			
		};
}
