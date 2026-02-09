{ config, lib, pkgs, flake, ... }: let
	
in {
	imports = [
		./hardware-configuration.nix
	];

	# homelab.dns."${config.networking.fqdn}" = "aaaaaaaa";
	
	services.openssh = {
		enable = true;

		settings = {
			
			PermitRootLogin = "no";
		};
	};
	
	environment.etc."comin-proof".text = "A";
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	programs.ssh.startAgent = true;

	networking = {
		networkmanager.enable = true;

		firewall.enable = false;

		nameservers = [ "1.1.1.1" "1.0.0.1" ];
		vlans.backbone = { interface = "enp1s0f1"; id = flake.homelab.networks.backbone.vlan; };


		interfaces.enp1s0f0.useDHCP = false;
		interfaces.enp1s0f1.useDHCP = false;
		interfaces.enp1s0f2.useDHCP = false;
		interfaces.enp1s0f3.useDHCP = false;
		interfaces.backbone.useDHCP = false;

		interfaces.enp1s0f0.ipv4.addresses = [{ address = "172.16.16.2"; prefixLength = 24; }];
		interfaces.enp1s0f0.ipv6.addresses = [{ address = flake.homelab.networks.management.static "2"; prefixLength = 64; }];
		interfaces.backbone.ipv6.addresses = [{ address = flake.homelab.networks.backbone.static "2"; prefixLength = 64; }];	
		#bridges.backbone-bridge.interfaces = [ "backkbone" ];

		defaultGateway = "172.16.16.1";
	};

	services.bind = {
		enable = false;
		listenOnIpv6 = let addr = builtins.elemAt config.networking.interfaces.backbone.ipv6.addresses 0; in [ "${addr.address}/${builtins.toString addr.prefixLength}" ];
		
	};

}
