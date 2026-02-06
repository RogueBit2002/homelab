{ self, lib, inputs, withSystem, ... }: {
	
	perSystem = { config, self', inputs', system, ... }: let
		pkgs = withSystem system ({ pkgs, ... }: pkgs);
	in {
		# Definitions like this are entirely equivalent to the ones
		# you may have directly in flake.nix.
		#packages.hello = pkgs.hello;

		apps.winbox = {
			type = "app";
			program = pkgs.writeShellScriptBin "run-winbox" ''
				${pkgs.winbox4}/bin/WinBox > /dev/null 2>&1 & disown
			'';
		};
	};
}
