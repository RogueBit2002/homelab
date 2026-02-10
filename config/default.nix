{ inputs, ... }: let
	trivial = inputs.nixpkgs.lib.trivial;
in {
	flake.homelab.networking = let

			root = "fd42:e2cd:499f";

			mkNetwork = hexId: {
				vlan = trivial.fromHexString hexId;
					
				# v4 = "172.16";
				prefix = "${root}:${hexId}::/64";
				static = segment: "${root}:${hexId}::${segment}";
			};
		in {
			domain = "crowsnest.homelab";
			ulaPrefix = "fd42:e2cd:449f";

			networks = {
				backbone = mkNetwork "b";
				management = mkNetwork "10";
			};
		};
}
