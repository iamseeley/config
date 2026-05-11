{ inputs, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/server.nix
    ../../modules/services/caddy.nix
    ../../modules/services/directus.nix
    ../../modules/services/umami.nix
    ../../modules/services/miniflux.nix
    ../../modules/services/shaarli.nix
  ];

  networking.hostName = "server-services";
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  age.secrets.tailscale-authkey.file = ../../secrets/tailscale-authkey-services.age;

  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscale-authkey.path;
  };

  system.stateVersion = "24.11";
}
