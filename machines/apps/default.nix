{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    ../../modules/nixos/server.nix
    ../../modules/nixos/hetzner.nix
    ../../modules/services/caddy.nix
    ../../modules/services/umami.nix
    ../../modules/services/miniflux.nix
    ../../modules/services/shaarli.nix
  ];

  networking.hostName = "apps";
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  system.stateVersion = "24.11";
}
