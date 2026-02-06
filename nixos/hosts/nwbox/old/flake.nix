{
	description = "nwbox configuration";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
	};

	outputs = { nixpkgs, ... }@inputs: let
		system = "x86_64-linux";
		
		pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
	in {
		nixosConfigurations.nwbox = nixpkgs.lib.nixosSystem {
			specialArgs = { inherit system; };

			inherit system;
			inherit pkgs;

			modules = [
				{
					networking.hostName = "nwbox";
					networking.domain = "crowsnest.homelab";
					system.stateVersion = "25.05";
					nix.settings.experimental-features = [ "nix-command" "flakes" ];

					environment.systemPackages = with pkgs; [
						wget
						git
						unzip
						mkpasswd
						ethtool
						dig
						tcpdump
					];

					boot.kernelPackages = pkgs.linuxPackages_latest;
				}

				({ ... } @ nixosInputs: let
					hwcfg = import ./hardware-configuration.nix (nixosInputs // { inherit pkgs; });
				in {
					fileSystems = hwcfg.fileSystems;
					swapDevices = hwcfg.swapDevices;
					hardware.cpu.intel.updateMicrocode = hwcfg.hardware.cpu.intel.updateMicrocode;
				})

				#(import ./hardware-configuration.nix)

				./modules/system/boot.nix
				
				#./modules/system/networking.nix
				{
					networking.networkmanager.enable = true;
				}
				./modules/system/users.nix
				./modules/system/locale.nix
				#./modules/ssh.nix
				#./modules/services/dhcp-dns.nix
				#./modules/backbone.nix
				#./modules/services/backbone.nix
				#./modules/services/nat64.nix
			];
		};
	};
}

