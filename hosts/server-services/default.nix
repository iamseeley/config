{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    ../../profiles/server.nix
    ../../modules/nixos/headless-grub.nix
    ../../modules/services/caddy.nix
    ../../modules/services/umami.nix
    ../../modules/services/miniflux.nix
    ../../modules/services/shaarli.nix
  ];

  networking.hostName = "server-services";
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  system.stateVersion = "24.11";
}
