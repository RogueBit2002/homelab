{ ... }: let
	hex = str: (builtins.fromTOML "hex = ${hex}").hex; 
in {
	flake.homelab-config = rec {
		networking = {
			domain = "crowsnest.homelab";

			vlans = {
				management = hex "0x10";
				trusted = hex "0x20";
				backbone = hex "0x7F";
			};
			ipv6 = {
				ULAPrefix = "fd42:e2cd:449f::/48";
				# make = suffix: networking.ipv6.ULAPrefix + 
			};
		};
	};
}
