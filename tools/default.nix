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

		/*apps.derv = {
			type = "app";
			program = pkgs.writeShellScriptBin "derv" ''
				echo ${builtins.readFile (pkgs.stdenv.mkDerivation {
					name = "derv";

					input = null;
					dontUnpack = true;

					installPhase = ''
						mkdir -p $out
						echo "12345" > $out/data
					'';
				} + /data)}
			'';
		};
		
		apps.derv2 = {
			type = "app";
			program = pkgs.writeShellScriptBin "derv" ''
				echo ${builtins.readFile } 
			'';
		};

		apps.my-test = {
			type = import (pkgs.stdenv.mkDerivation {
					name = "derv";

					input = null;
					dontUnpack = true;

					installPhase = ''
						mkdir -p $out
						echo "\"app\"" > $out/module
					'';
				} + /module);
			program = config.apps.derv.program;
		};*/
	};
}
