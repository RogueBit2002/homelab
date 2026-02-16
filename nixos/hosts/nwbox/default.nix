{ config, lib, pkgs, flake, homelab, ... }: {
	imports = [
		./hardware-configuration.nix
	];

	# homelab.dns."${config.networking.fqdn}" = "aaaaaaaa";
	
	services.openssh = {
		enable = true;

		settings = {
			
			PermitRootLogin = "no";
		};
	};
	
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	programs.ssh.startAgent = true;

	networking = {
		firewall.enable = false;

		nameservers = [ "1.1.1.1" "1.0.0.1" ];
		vlans.backbone = { interface = "enp1s0f1"; id = homelab.networking.networks.backbone.vlan; };

		useDHCP = false;
		interfaces.enp1s0f0.useDHCP = false;
		interfaces.enp1s0f1.useDHCP = false;
		interfaces.enp1s0f2.useDHCP = false;
		interfaces.enp1s0f3.useDHCP = false;
		interfaces.backbone.useDHCP = false;

		interfaces.backbone.tempAddress = "disabled";
		interfaces.enp1s0f0.ipv4.addresses = [{ address = "172.16.16.2"; prefixLength = 24; }];
		interfaces.enp1s0f0.ipv6.addresses = [{ address = homelab.networking.networks.management.static "2"; prefixLength = 64; }];
		interfaces.backbone.ipv6.addresses = [{ address = homelab.networking.networks.backbone.static "2"; prefixLength = 64; }];	

		defaultGateway = "172.16.16.1";
		defaultGateway6 = {
			address = homelab.networking.networks.management.static "1";
			interface = "enp1s0f0";
		};
	};

	/*services.bind = {
		enable = false;
		listenOnIpv6 = let addr = builtins.elemAt config.networking.interfaces.backbone.ipv6.addresses 0; in [ "${addr.address}/${builtins.toString addr.prefixLength}" ];
		
	};*/

	services.unbound = {
		enable = true;

		settings = {
			server = {
				interface = [ 
					"::1"
					(builtins.elemAt config.networking.interfaces.backbone.ipv6.addresses 0).address
				];

				do-not-query-localhost = false;

				access-control = [
					"::1 allow"
					"${homelab.networking.ulaPrefix}::0/48 allow"
				];

				
			};
		};
	};

/*
			services.unbound = {
				enable = true;

				settings = {
					server = {
						interface = [ "10.0.99.2" ];
						#port = 8000;



						#local-data = builtins.map 
						#	(entry: "\"${entry.name}. A ${entry.address}\"") records;

						do-not-query-localhost = false;
						

						access-control = [
							"127.0.0.1 allow_snoop"
							"10.0.0.0/16 allow_snoop"
						];

						access-control-view = builtins.map 
							(view: "${view.subnet} " + builtins.hashString "sha1" view.subnet) views;


						#view = [ "name: \"xxxx\"" ];
						view = builtins.map (view:
							"name: \"${builtins.hashString "sha1" view.subnet}\"\n" +
							(builtins.foldl' (acc: record: 
								acc + "local-data: \"${record.name}. A ${record.address}\"\n"
							) "" view.records)
						) views;
						#view =builtins.map (view: "name: \"\"") C;
					};

					forward-zone = [
						{
							name = ".";
							forward-tls-upstream = false; #Normally this would be true, but adguard is local, so doesn't need encryption
							forward-addr = [ "10.0.99.3@53" ];
							/*forward-addr = [
								"1.1.1.1@853#cloudflare-dns.com"
								"1.0.0.1@853#cloudflare-dns.com"
							];*/

					#	}
				#	];
			#	};

			#};*/


	

}
