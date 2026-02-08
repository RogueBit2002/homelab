{
	description = "Homelab Flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
		flake-parts.url = "github:hercules-ci/flake-parts";

		comin = {
			url = "github:nlewo/comin?tag=v0.10.0";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { ... }@inputs:
		inputs.flake-parts.lib.mkFlake { inherit inputs; } {
			imports = [

				./nixos
				./infra
				./tools
				./config


				({ ... }: { 
					perSystem = { system, ... }: {
						_module.args.pkgs = import inputs.nixpkgs { inherit system; config.allowUnfree = true; };
					};
				})
			];
			
			systems = [ "x86_64-linux" ];
		};
}
