{ self, ... }: {
	perSystem = { system, pkgs, config, ... }: {
		packages.terraform = pkgs.opentofu.withPlugins (p: [ p.terraform-routeros_routeros ] );

		devShells.iac = pkgs.mkShell {
			packages = [ 
				config.packages.terraform
			];
		};
	};


	flake.infra = {
		devices = {
		};
	};

	# flake.homelab.infra = {
			
	# };
}
