{ self, ... }: {

	flake.primary-user = "roguebit";
	
	flake.nixosModules.users = { ... }: {	
		
		users.mutableUsers = false;
		
		users.users.root.password = "hello";
		users.users.${self.primary-user} = {
			uid = 1000;
			isNormalUser = true;
			extraGroups = [ "wheel" ];
			password = "hello"; # Let's just pretend this is secure
		};
	};
}
