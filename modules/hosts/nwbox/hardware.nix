{ ... }: {
	flake.nixosModules.nwbox-hardware = { ... }: {

		imports = [
			# Auto generated config
			({ config, lib, pkgs, modulesPath, ... }: {
				imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
	
				boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
				boot.initrd.kernelModules = [ ];
				boot.kernelModules = [ "kvm-intel" ];
				boot.extraModulePackages = [ ];

				fileSystems."/" = {
					device = "tmpfs";
					fsType = "tmpfs";
    			};

  				fileSystems."/nix" = {
					device = "/dev/disk/by-uuid/502d6f81-1412-46f9-a1b9-0eb8c80fd849";
      				fsType = "btrfs";
      				options = [ "subvol=@nix" ];
    			};

				fileSystems."/persist" = {
					device = "/dev/disk/by-uuid/502d6f81-1412-46f9-a1b9-0eb8c80fd849";
      				fsType = "btrfs";
      				options = [ "subvol=@persist" ];
    			};
	
  				fileSystems."/var/log" = {
					device = "/dev/disk/by-uuid/502d6f81-1412-46f9-a1b9-0eb8c80fd849";
	      			fsType = "btrfs";
	      			options = [ "subvol=@log" ];
	    		};

	  			fileSystems."/boot" = {
					device = "/dev/disk/by-uuid/BC3D-57EC";
					fsType = "vfat";
					options = [ "fmask=0077" "dmask=0077" ];
	    		};

	  			swapDevices = [
					{ device = "/dev/disk/by-uuid/a2e554a8-96cf-4169-92a2-5a45f2586e5a"; }
	    		];

				nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
				hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
			})

			# Patches
			({ ... }: {
				fileSystems."/".options = [ "mode=0755" "size=4G" ];
				fileSystems."/persist".neededForBoot = true;
				fileSystems."/var/log".neededForBoot = true;
			})
		];
	};
}
