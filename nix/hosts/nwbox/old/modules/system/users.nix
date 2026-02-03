{ config, pkgs, ... }:

{
  users.mutableUsers = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.laurens = {
    isNormalUser = true;
    description = "laurens";
    extraGroups = [ "networkmanager" "wheel" ];
    hashedPassword = "$6$WwnvtTAaL80X5WD7$VVO8lC815yHWtGsf10kfkObwPibk9J.Sn2hpL.NCbuX0mKsvj4QeUChRKY4g1uc0enlQJml0Tkm0kNuGAaiix0";
  };

  users.users.root.hashedPassword = "$6$WwnvtTAaL80X5WD7$VVO8lC815yHWtGsf10kfkObwPibk9J.Sn2hpL.NCbuX0mKsvj4QeUChRKY4g1uc0enlQJml0Tkm0kNuGAaiix0";
}
