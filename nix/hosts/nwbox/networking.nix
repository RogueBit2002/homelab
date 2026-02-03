{ ... }: {
	/*systemd.network = {
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
			networkConfig = { Address = "172.16.0.2/24"; };
		};

		networks."enp1s0f0" = {
			matchConfig = { Name = "enp1s0f0"; };

			networkConfig = { VLAN="management"; };
		};
	};*/

	networking = {
		networkmanager.enable = true;
	};
}
