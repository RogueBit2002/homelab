{ self, inputs, ... }: {

	flake.dns."foo.crowsnest.sh".v4 = "123.123.123.123";

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
				
				security.sudo.extraConfig = ''
					Defaults lecture = never
				'';

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
					interfaces.backbone.ipv6.addresses = [{ address = "fd42:e2cd:449f:b::2"; prefixLength = 64; }];

					defaultGateway = "172.16.16.1";

					defaultGateway6 = {
						address = "fd42:e2cd:449f:10::1";
						interface = "enp1s0f0";
					};
				};

				powerManagement.cpuFreqGovernor = "powersave";


				services.unbound = {
					enable = true;

					settings = {
						interface = [
							"::1"
							"fd42:e2cd:449f:b::2"
						];

						do-not-query-localhost = "no";

						access-control = [
							"::1 allow"
							"fd42:e2cd:449f::0/48 allow"
						];

						local-zone = [ "\"crowsnest.sh.\" transparent" ];
						local-data = builtins.foldl' (entries: record: 
							entries 
							++ (lib.optionals (self.dns.${record}.v4 != null) [ "\"${record}. A ${self.dns.${record}.v4}\"" ]) 
							++ (lib.optionals (self.dns.${record}.v6 != null) [ "\"${record}. AAAA ${self.dns.${record}.v6}\"" ]) 
						) [] (builtins.attrNames self.dns);

					};
				};
			})
		];
	};
}
