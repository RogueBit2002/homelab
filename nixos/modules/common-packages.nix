{ pkgs, ... }: {
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
