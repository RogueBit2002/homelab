{ pkgs, lib, config, ... }: let
	cfg = config.backbone;
in {
	/*options = {	
		services.backbone = {
			enable = lib.mkEnableOption "Enable the backbone services";

			interface = lib.mkOption { 
				type = lib.types.string;
				default = null;	
				description = "The interface used for communication between the backbone and the network";
			};

			address = lib.mkOption {
				type = lib.types.submodule {
					options = {
						address = lib.mkOption {
							type = lib.types.string;
						};

						prefixLength = lib.mkOption {
							type = lib.types.ints.between 0 31;
						};
					};
				};

				description = "The address the backbone container will use";
			};
		};
	};*/


	networking = {
		#networkmanager.enable = true;

		vlans.management = { interface = "enp1s0f0"; id = 10; };
		vlans.backbone = { interface = "enp1s0f1"; id = 99; };

		interfaces.enp1s0f0.useDHCP = false;
		interfaces.enp1s0f1.useDHCP = false;
		
		interfaces.management.useDHCP = false;
		interfaces.backbone.useDHCP = false;

		interfaces.management.ipv4.addresses = [{ address = "10.10.0.2"; prefixLength = 24; }];
				
		bridges.br0 = {
			interfaces = [ "backbone" ];
		};

		defaultGateway = "10.10.0.1";

		nameservers = [ "10.99.0.2" ]; 
	};

	containers.backbone = {
		autoStart = true;
		ephemeral = true;
	
		privateNetwork = true;
 		hostBridge = "br0";

		bindMounts."/var/lib/dnsmasq" = {
			hostPath = "/var/lib/dnsmasq";
			isReadOnly = false;
		};

		config = { config, lib, pkgs, ... }: {
			networking = {
				interfaces.eth0.useDHCP = false;
			
				interfaces.eth0.ipv4.addresses = [{ address = "10.99.0.2"; prefixLength = 24; }];
		
				defaultGateway = "10.99.0.1";
				nameservers = [ "127.0.0.1" ];

				firewall.interfaces.eth0.allowedUDPPorts = [ 53 67 68 ];
				firewall.interfaces.eth0.allowedTCPPorts = [ 53 67 68 ];
			};

			services.dnsmasq = {
				enable = true;
		
				resolveLocalQueries = true;

				settings = {
					server = [ "8.8.8.8" "8.8.4.4" ];
					
					interface="eth0";
								
					bind-interfaces = true;
					dhcp-authoritative = true;
					log-dhcp = true;
					dhcp-range = [ 
						"10.0.0.50,10.0.0.100,255.255.255.0,24h"
						"set:v10, 10.10.0.100, 10.10.0.254, 255.255.255.0, 24h"
						"set:v20, 10.20.0.100, 10.20.0.254, 255.255.255.0, 24h"
						"set:v30, 10.30.0.2, 10.30.0.254, 255.255.255.0, 24h"
						"set:v40, 10.40.0.2, 10.40.0.254, 255.255.255.0, 24h"

/*
10 management
20 devices
25 devices - vpn
30 guest
40 services

*/
					];

					dhcp-option = [
						"option:router,10.0.0.1"
						"tag:v10,option:router,10.10.0.1"
						"tag:v20,option:router,10.20.0.1"
						"tag:v30,option:router,10.30.0.1"
						"tag:v40,option:router,10.40.0.1"
					];

					address = [
						"/nwbox.crowsnest.homelab/10.10.0.2"
					]; 	

					port = 53;
				};		
			};
		};
	};	
}
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

			#};
			/*
			services.adguardhome = {
				enable = true;

				settings = {
					http = { address = "10.0.1.102:80"; };
					dns = {
						bind_hosts = [ "10.0.99.2" ];
						port = 53;
						upstream_dns = [
							"127.0.0.1:8000"
						];
					};

					filtering = {
						protection_enabled = true;
						filtering_enabled = true;

						parental_enabled = false;
						safe_search.enabled = false;

						
					};
				};
			};*/
#		};
#	};	
#}
