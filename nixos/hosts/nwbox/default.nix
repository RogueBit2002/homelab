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

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	programs.ssh.startAgent = true;

	networking = {
		networkmanager.enable = true;

		firewall.enable = false;


		vlans.backbone = { interface = "enp1s0f1"; id = flake.homelab.networks.backbone.vlan; };


		interfaces.enp1s0f0.useDHCP = false;
		interfaces.enp1s0f1.useDHCP = false;

		interfaces.enp1s0f0.ipv6.addresses = [{ address = flake.homelab.networks.management.static "2"; prefix = 64; }];
		interfaces.backbone.ipv4.addresses = [{ address = flake.homelab.networks.backbone.static "2"; prefixLength = 64; }];	
		#bridges.backbone-bridge.interfaces = [ "backkbone" ];

			
	};

	

}
