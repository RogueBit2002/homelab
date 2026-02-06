{ self, lib, inputs, withSystem, ... }: {
	flake = {
		
		nixosConfigurations = let 

			mkSystem = fqdnPrefix: let
				fqdnPrefixParts = builtins.match "([^.]*)\\.(.*)" fqdnPrefix;

				hostName = if fqdnPrefixParts != null then builtins.elemAt fqdnPrefixParts 0 else fqdnPrefix;
				domain = (if fqdnPrefixParts != null then "${builtins.elemAt fqdnPrefixParts 1}." else "") + self.homelab-config.networking.domain;

			in inputs.nixpkgs.lib.nixosSystem {
				modules = [
					inputs.nixpgs.nixosModules.readOnlyPkgs
					inputs.comin.nixosModules.comin
					
					({ config, ... }: let
						pkgs = withSystem config.nixpkgs.hostPlatform.system ({ pkgs, ... }: pkgs);
					in {
						nixpkgs.pkgs = pkgs;
						nix.settings.experimentalFeatures = [ "nix-command" "flakes" ];

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
				];
			};
		in {
			"nwbox" = mkSystem "nwbox";
		};
	};

}

