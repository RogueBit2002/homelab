{ lib, ... }: {
	systemd.network = {
		enable = false;

		netdevs."management" = {
			
			netdevConfig = {
				Kind = "vlan";
				Name = "management";
			};

			vlanConfig = {
				Id = 16;
			};


		};

		networks."management" = {
			matchConfig = { Name = "management"; };
			networkConfig = { Address = "10.0.16.2/24"; };
		};

		networks."enp1s0f0" = {
			matchConfig = { Name = "enp1s0f0"; };

			networkConfig = { VLAN="management"; };
		};
	};

	
	networking.useDHCP = lib.mkDefault false;

	
	#systemd.network.enable = true;
	#networking.useDHCP = lib.mkDefault false;
	#networking.networkmanager.enable = true;
	#networking.useDHCP = lib.mkDefault true;

	/*
	services.openssh = {
		enable = true;

		listenAddresses = [ { addr = "10.0.16.2"; } ];
		settings = {
			PermitRootLogin = "no";
		};
	};*/
}
