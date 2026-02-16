{ config, homelab, ... }: let

	managementAddress = homelab.networking.networks.management.static "2";
	backboneAddress = homelab.networking.networks.backbone.static "2";
in {
	imports = [
		./hardware-configuration.nix
	];
	
	services.openssh = {
		enable = true;

		listenAddresses = [ managementAddress ];
		settings = {
			PermitRootLogin = "no";
		};
	};
	
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	programs.ssh.startAgent = true;

	networking = {
		firewall.enable = false;

		nameservers = [ "1.1.1.1" "1.0.0.1" ];
		vlans.backbone = { interface = "enp1s0f1"; id = homelab.networking.networks.backbone.vlan; };

		useDHCP = false;
		interfaces.enp1s0f0.useDHCP = false;
		interfaces.enp1s0f1.useDHCP = false;
		interfaces.enp1s0f2.useDHCP = false;
		interfaces.enp1s0f3.useDHCP = false;
		interfaces.backbone.useDHCP = false;

		interfaces.backbone.tempAddress = "disabled";
		interfaces.enp1s0f0.ipv4.addresses = [{ address = "172.16.16.2"; prefixLength = 24; }];
		interfaces.enp1s0f0.ipv6.addresses = [{ address = managementAddress; prefixLength = 64; }];
		interfaces.backbone.ipv6.addresses = [{ address = backboneAddress; prefixLength = 64; }];	

		defaultGateway = "172.16.16.1";
		defaultGateway6 = {
			address = homelab.networking.networks.management.static "1";
			interface = "enp1s0f0";
		};
	};

	services.unbound = {
		enable = true;

		settings = {
			server = {
				interface = [ 
					"::1"
					backboneAddress
				];

				# control-enable = "yes";
				do-not-query-localhost = false;

				access-control = [
					"::1 allow"
					"${homelab.networking.ulaPrefix}::0/48 allow"
				];

				local-zone = [ "\"${homelab.networking.domain}.\" transparent" ];
				local-data = builtins.foldl' (acc: name: acc ++ [ "\"${name}. AAAA ${homelab.dns.${name}}\"" ]) [] (builtins.attrNames homelab.dns);
			};
		};
	};
}
