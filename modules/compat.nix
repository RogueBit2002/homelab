{ ... }: {
	flake.nixosModules.compat = { pkgs, ... }: {
		programs.nix-ld.enable = true;

		programs.appimage.enable = true;
		programs.appimage.binfmt = true;

		environment.systemPackages = with pkgs; [
			wine
		];
	};
}
