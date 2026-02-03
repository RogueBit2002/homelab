{
	description = "System flake for my homelab's NixOS hosts";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs?tag=25.11";
	};

	outputs = { self, nixpkgs, ... }@inputs: let

		baseDomain = "crowsnest.homelab";

		mkSystem = fqdnPrefix: system: let
			fqdnPrefixParts = builtins.match "([^.]*)\\.(.*)" fqdnPrefix;

			hostName = if fqdnPrefixParts != null then builtins.elemAt fqdnPrefixParts 0 else fqdnPrefix;
			domain = if fqdnPrefixParts != null then builtins.elemAt fqdnPrefixParts 1 + ".${baseDomain}" else baseDomain;

		in nixpkgs.lib.nixosSystem {
			inherit system;
			pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };

			specialArgs = { inherit inputs; flake = self; };

			modules = [
				{
					nix.settings.experimental-features = [ "nix-command" "flakes" ];

					networking.hostName = hostName;
					networking.domain = domain;

					system.stateVersion = "25.11";
				}
				./hosts/${hostName}
			];
		};
	in {
		nixosConfigurations = builtins.foldl' (acc: system: acc // { "${system.config.networking.hostName}" = system; }) {}
			[
				(mkSystem "nwbox" "x86_64-linux" )
			];
	};
}
