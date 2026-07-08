{ lib, ... }: {
	/*flake.networking = rec {
		domain = "crowsnest.sh";
		ula-prefix = "fd42:e2cd:449f";
			
		mkNetwork = hexId: { 
			vlan = lib.trivial.fromHexString hexId;
			prefix = "${ula-prefix}:${hexId}::/64";
			static = suffix: "${ula-prefix}:${hexId}::${suffix}";
		};

		networks = {
			backbone = mkNetwork "b";
			management = mkNetwork "10";
		};	
	};*/
}
