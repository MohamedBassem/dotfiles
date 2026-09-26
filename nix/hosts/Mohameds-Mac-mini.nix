{ config, ... }:
{
  # Headless machine: shared darwin modules only, no casks or UI defaults.
  services.openssh.extraConfig = ''
    PasswordAuthentication no
    KbdInteractiveAuthentication no
  '';

  home-manager.users.${config.system.primaryUser}.programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "~/.orbstack/ssh/config" ];
    settings."*".AddKeysToAgent = "yes";
  };
}
