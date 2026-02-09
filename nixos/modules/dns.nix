{ config, lib, pkgs, ... }: let 
	cfg = config.homelab.dns;
in {
	
	options.homelab.dns = lib.mkOption {
		type = lib.types.attrsOf lib.types.str;
		default = {};
	};
}
