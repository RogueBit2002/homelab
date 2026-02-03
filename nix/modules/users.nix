{ ... }: let 
	hashedPassword = "$6$j0YBAdyHcdVbF0Dp$xtvgXEUqDOlk3zBa1NKjln66eNOp.5pwq23y09LGrtTRRe79P7EQdtJHiusGc0uwDr2z6e3AUsD0VBc5CGrXA.";
in {
	users.mutableUsers = false;

	users.users.root.hashedPassword = hashedPassword;
	users.users.laurens = {
		isNormalUser = true;
		createHome = true;
		description = "Laurens";

		hashedPassword = hashedPassword;
		extraGroups = [ "networkmanager" "wheel" "docker" ];	
	};
}
