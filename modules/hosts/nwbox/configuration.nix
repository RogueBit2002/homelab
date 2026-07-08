{ self, inputs, ... }: {
	flake.nixosConfigurations.nwbox = inputs.nixpkgs.lib.nixosSystem {
		
		modules = [
			self.nixosModules.nwbox-hardware

			inputs.impermanence.nixosModules.impermanence
			inputs.comin.nixosModules.comin

			self.nixosModules.nix
			self.nixosModules.users
			self.nixosModules.i18n
			self.nixosModules.compat

			({ pkgs, lib, ... }: {
				system.stateVersion = "26.05";

				boot.loader.systemd-boot.enable = true;
				boot.loader.efi.canTouchEfiVariables = true;
				boot.kernelPackages = pkgs.linuxPackages_7_0;

				networking.hostName = "nwbox";
				networking.domain = "crowsnest.sh";

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
						"/var/lib/comin" # Not sure about this one
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
				
				networking = {
					firewall.enable = false; # Should probably turn this on at some point

					nameservers = [ "1.1.1.1" "1.0.0.1" ];
					vlans.backbone = { interface = "enp1s0f1"; id = 11; }; # b

					useDHCP = false;
					interfaces.enp1s0f0.useDHCP = false;
					interfaces.enp1s0f1.useDHCP = false;
					interfaces.enp1s0f2.useDHCP = false;
					interfaces.enp1s0f3.useDHCP = false;
					interfaces.backbone.useDHCP = false;

					interfaces.backbone.tempAddress = "disabled";
					interfaces.enp1s0f0.ipv4.addresses = [{ address = "172.16.16.2"; prefixLength = 24; }];
					interfaces.enp1s0f0.ipv6.addresses = [{ address = "fd42:e2cd:449f:10::2"; prefixLength = 64; }];
					interfaces.enp1s0f1.ipv6.addresses = [{ address = "fd42:e2cd:449f:b::2"; prefixLength = 64; }];

					defaultGateway = "172.16.16.1";
					defaultGateway6 = {
						address = "fd42:e2cd:449f:10::1";
						interface = "enp1s0f0";
					};
				};

				powerManagement.cpuFreqGovernor = "powersave";
			})
		];
	};
}
