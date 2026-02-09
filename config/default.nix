{ inputs, ... }: let
	trivial = inputs.nixpkgs.trivial;
in {
	flake.homelab.domain = "crowsnest.homelab";
	flake.homelab.networks = let

				root = "fd42:e2cd:499f";

				mkNetwork = hexId: {
					vlan = trivial.fromHexString hexId;
					
					# v4 = "172.16";
					prefix = "${root}:${hexId}::/64";

					static = segment: "${root}:${hexId}:${segment}";
				};
			in {
				backbone = mkNetwork "B";
				management = mkNetwork "10";
			};
}
