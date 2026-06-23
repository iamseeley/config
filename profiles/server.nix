{ inputs, config, pkgs, ... }: {
  imports = [
    ../modules/nixos/base.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    htop
    docker-compose
  ];

  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };

  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscale-authkey.path;
  };

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
