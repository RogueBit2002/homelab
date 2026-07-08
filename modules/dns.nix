{ lib, flake-parts-lib, ... }: {
	options = {
		flake = flake-parts-lib.mkSubmoduleOptions {
			dns = lib.mkOption {
				type = lib.types.attrsOf (lib.types.submodule {
					options = {
						v4 = lib.mkOption { type = lib.types.nullOr lib.types.str; default = null; };
						v6 = lib.mkOption { type = lib.types.nullOr lib.types.str; default = null; };
					};
				});
				default = {};
			};
		};
	};
}
