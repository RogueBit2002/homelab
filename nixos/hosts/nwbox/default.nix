{ config, lib, pkgs, flake, ... }:

{
	imports = [
		./hardware-configuration.nix

		(flake + /modules/users.nix)
		(flake + /modules/i18n.nix)
		(flake + /modules/common-packages.nix)
		
	];
	
	services.openssh = {
		enable = true;

		listenAddresses = [ { addr = "172.16.0.2"; } ];
		settings = {
			PermitRootLogin = "no";
		};
	};

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	#programs.ssh.startAgent = true;

	/*programs.ssh.knownHosts = {
		github = {
			hostNames = [ "github.com" ];
			publicKeyFile = /root/.ssh/id_25519-homelab-repo.pub;
		};
	};*/
	networking = {
		networkmanager.enable = true;

		interfaces.enp2s0.useDHCP = true;
		interfaces.enp1s0f0.useDHCP = true;
		#interfaces."enp1s0f0" = { useDHCP = false; ipv4.addresses = [ { address = "172.16.16.2"; prefixLength = 24; } ]; };
		
		#defaultGateway.address = "172.16.16.2";
		nameservers = [ "1.1.1.1" "1.0.0.1" ];
	};


  	
	#networking.interfaces.enp2s0.useDHCP = true;
}
