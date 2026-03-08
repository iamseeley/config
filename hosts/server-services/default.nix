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

  system.stateVersion = "24.11";
}
