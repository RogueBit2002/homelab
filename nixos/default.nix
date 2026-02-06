{ self, lib, inputs, withSystem, ... }: {
	flake = {
		/*nixosModules.hello = { pkgs, ... }: {
			environment.systemPackages = [
			# or self.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.hello
			self.packages.${pkgs.stdenv.hostPlatform.system}.hello
      		];
		};*/

		nixosConfigurations = let 

			mkSystem = fqdnPrefix: let
				fqdnPrefixParts = builtins.match "([^.]*)\\.(.*)" fqdnPrefix;

				hostName = if fqdnPrefixParts != null then builtins.elemAt fqdnPrefixParts 0 else fqdnPrefix;
				domain = (if fqdnPrefixParts != null then "${builtins.elemAt fqdnPrefixParts 1}." else "") + self.homelab-config.networking.domain;

			in inputs.nixpkgs.lib.nixosSystem {
				modules = [
					inputs.nixpgs.nixosModules.readOnlyPkgs
					inputs.comin.nixosModules.comin
					
					({ config, ... }: {
						nixpkgs.pkgs = withSystem config.nixpkgs.hostPlatform.system ({ pkgs, ... }: pkgs);
						nix.settings.experimentalFeatures = [ "nix-command" "flakes" ];

						networking.hostName = hostName;
						networking.domain = domain;
						
						system.stateVersion = "25.11";
					})

					./hosts/${fqdnPrefix}
				];
			};
		in {
			"nwbox" = mkSystem "nwbox";
		};
	};

}

