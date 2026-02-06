{ self, lib, inputs, withSystem, ... }: {
	flake = {
		
		nixosConfigurations = let 

			mkSystem = fqdnPrefix: system: let
				fqdnPrefixParts = builtins.match "([^.]*)\\.(.*)" fqdnPrefix;

				hostName = if fqdnPrefixParts != null then builtins.elemAt fqdnPrefixParts 0 else fqdnPrefix;
				domain = (if fqdnPrefixParts != null then "${builtins.elemAt fqdnPrefixParts 1}." else "") + self.homelab-config.networking.domain;

			in inputs.nixpkgs.lib.nixosSystem {

				pkgs = withSystem system ({ pkgs, ... }: pkgs);
				inherit system;

				specialArgs = { flake = self; };

				modules = [
					inputs.comin.nixosModules.comin
							
				
					({ pkgs, ... }: {
						nix.settings.experimental-features = [ "nix-command" "flakes" ];

						networking.hostName = hostName;
						networking.domain = domain;
						
						services.comin = {
              				enable = true;
							remotes = [{
								name = "origin";
								url = "ssh+git://git@github.com/RogueBit2002/homelab.git";
								branches.main.name = "main";
							}];
            			};

						systemd.services.comin.environment.GIT_SSH_COMMAND = "${pkgs.openssh}/bin/ssh -i /etc/ssh/homelab/ed25519_repo";


						system.stateVersion = "25.11";
					})

					./hosts/${fqdnPrefix}


# inputs.nixpkgs.nixosModules.readOnlyPkgs	({ config, ... }: { nixpkgs.pkgs = withSystem config.nixpkgs.hostPlatform.system ({ pkgs, ... }: pkgs); })

				];
			};
		in {
			"nwbox" = mkSystem "nwbox" "x86_64-linux";
		};
	};

}

