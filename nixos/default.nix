{ self, lib, inputs, withSystem, ... }: {
	flake = {
		
		nixosConfigurations = let 

			mkSystem = fqdnPrefix: let
				fqdnPrefixParts = builtins.match "([^.]*)\\.(.*)" fqdnPrefix;

				hostName = if fqdnPrefixParts != null then builtins.elemAt fqdnPrefixParts 0 else fqdnPrefix;
				domain = (if fqdnPrefixParts != null then "${builtins.elemAt fqdnPrefixParts 1}." else "") + self.homelab-config.networking.domain;

			in inputs.nixpkgs.lib.nixosSystem {

				specialArgs = { flake = self; };

				modules = [
					inputs.comin.nixosModules.comin
					inputs.nixpkgs.nixosModules.readOnlyPkgs		
					({ config, ... }: { nixpkgs.pkgs = withSystem config.nixpkgs.hostPlatform.system ({ pkgs, ... }: pkgs); })

					({ pkgs, ... }: {
						nix.settings.experimentalFeatures = [ "nix-command" "flakes" ];

						networking.hostName = hostName;
						networking.domain = domain;
						
						
						system.stateVersion = "25.11";
					})

					./hosts/${fqdnPrefix}
					./modules/comin.nix
				];
			};
		in {
			"nwbox" = mkSystem "nwbox";
		};
	};

}

