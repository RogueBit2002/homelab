{ pkgs, ... }: {
	imports = [
		./comin.nix
		./i18n.nix
		./users.nix
	];

	environment.systemPackages = with pkgs; [
		git
		wget
		lm_sensors
		mkpasswd
		dig
		zip
		unzip
		gnumake
		gnutar
	];
}
