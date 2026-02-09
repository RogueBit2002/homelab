{ inputs, ... }: let
	hex = str: (builtins.fromTOML "hex = ${hex}").hex;

	trivial = inputs.nixpkgs.trivial;
in {
	flake.homelab.domain = "crowsnest.homelab";
	flake.homelab.networks = let

				root = "fd42:e2cd:499f";

				mkNetwork = hexId: {
					vlan = trivial.fromHexString hexId;
					
					# v4 = "172.16";
					prefix = "${root}:${hex}::/64";

					static = segment: "${root}:${hex}:${segment}";
				};
			in {
				backbone = mkNetwork "B";
				management = mkNetwork "10";
			};
}
