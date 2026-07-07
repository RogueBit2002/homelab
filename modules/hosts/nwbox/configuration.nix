{ self, inputs, ... }: {
	flake.nixosConfigurations.nwbox = inputs.nixpkgs.lib.nixosSystem {
		
		modules = [
			self.nixosModules.nwbox-hardware

			inputs.impermanence.nixosModules.impermanence
			inputs.comin.nixosModules.comin

			self.nixosModules.nix
			self.nixosModules.users
			self.nixosModules.i18n

			({ pkgs, lib, ... }: {
				system.stateVersion = "26.05";

				boot.loader.systemd-boot.enable = true;
				boot.loader.efi.canTouchEfiVariables = true;

				networking.hostName = "nwbox";
				networking.domain = "crowsnest.sh";

				networking.networkmanager.enable = true;

				environment.systemPackages = with pkgs; [
					git
					wget
					dig
					age
					sops
					unzip
					lm_sensors
				];

				environment.persistence."/persist" = {
					enable = true;
					directories = [
						"/etc/nixos"
					];

					files = [
						"/etc/machine-id"
					];
				};

				services.comin = {
					enable = true;
					hostname = "nwbox";
					remotes = [{
						name = "origin";
						url = "https://github.com/RogueBit2002/homelab";
					}];
				};

				networking.interfaces.enp1s0f0.useDHCP = false;
				networking.interfaces.enp1s0f1.useDHCP = false;
				networking.interfaces.enp1s0f2.useDHCP = false;
				networking.interfaces.enp1s0f3.useDHCP = false;

			})
		];
	};
}
