{ pkgs, ... }: {
	services.comin = {
              				enable = true;
							remotes = [{
								name = "origin";
								url = "git+ssh://git@github.com/RogueBit2002/homelab.git";
								branches.main.name = "main";
							}];
            			};

						systemd.services.comin.environment.GIT_SSH_COMMAND = "${pkgs.openssh}/bin/ssh -i /etc/ssh/homelab/ed25519_repo";


}
