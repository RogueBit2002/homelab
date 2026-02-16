{ self, lib, inputs, withSystem, ... }: {
	flake = {
		
		nixosConfigurations = let 

			mkSystem = fqdnPrefix: system: let
				fqdnPrefixParts = builtins.match "([^.]*)\\.(.*)" fqdnPrefix;

				hostName = if fqdnPrefixParts != null then builtins.elemAt fqdnPrefixParts 0 else fqdnPrefix;
				domain = "${(if fqdnPrefixParts != null then "${builtins.elemAt fqdnPrefixParts 1}." else "")}${self.networking.domain}";

			in inputs.nixpkgs.lib.nixosSystem {

				pkgs = withSystem system ({ pkgs, ... }: pkgs);
				inherit system;

				specialArgs = { 
					flake = self;
					homelab = {
						networking = self.networking;
						dns = self.dns;
					};
				};

				modules = [
					({ pkgs, ... }: {
						nix.settings.experimental-features = [ "nix-command" "flakes" ];

						networking.hostName = hostName;
						networking.domain = domain;
						
						
						system.stateVersion = "25.11";
					})
					
					inputs.comin.nixosModules.comin

					./common	
					./hosts/${hostName}
				];
			};
		in builtins.foldl' (acc: system: acc // { ${system.config.networking.hostName} = system; }) {} [
			(mkSystem "nwbox.infra" "x86_64-linux")
		];
	};

}

