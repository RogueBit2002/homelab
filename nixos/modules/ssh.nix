{ ... }: {
	services.openssh = {
		enable = true;

		listenAddresses = [ { addr = "172.16.0.2"; } ];
		settings = {
			PermitRootLogin = "no";
		};
	};
}
