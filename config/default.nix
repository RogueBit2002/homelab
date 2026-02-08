{ inputs, ... }: let
	hex = str: (builtins.fromTOML "hex = ${hex}").hex; 
in {
	flake.homelab-config = {
		networking = {
			domain = "crowsnest.homelab";
			networks = let 
				rootULA = "fd42:e2cd:449f";

				mkNetwork = hexId: let
					id = hex hexId;
				in {
					ipv4.subnet = "172.16.${id}.0/24";
					ipv6.ula = "${rootULA}:${hex}::/64";
				};

			in {
				management = mkNetwork "0x10";				
			};
			vlans = {
				backbone = hex "0x08";
				management = hex "0x10";
				trusted = hex "0x20";
			};
			ipv6 = let
				rawULA = "fd42:e2cd:449f:";
			in {
				rootULAPrefix = "${rawULA}:/48";
				mkULA = vlan: rawULA;
				# make = suffix: networking.ipv6.ULAPrefix + 
			};
		};
	};
}
