{ self, inputs, ... }: {
	flake.dns = {
		
		${self.nixosConfigurations.nwbox.config.networking.fqdnOrHostName} = (builtins.elemAt self.nixosConfigurations.nwbox.config.networking.interfaces.enp1s0f0.ipv6.addresses 0).address;	
	};
}
