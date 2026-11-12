{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    ../../modules/nixos/server.nix
    ../../modules/nixos/hetzner.nix
    ../../modules/services/umami.nix
    ../../modules/services/miniflux.nix
    ../../modules/services/shaarli.nix
    ../../modules/services/tseeley-site.nix
  ];

  networking.hostName = "apps";

  system.stateVersion = "24.11";
}
