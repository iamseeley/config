{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    ../../modules/nixos/server.nix
    ../../modules/nixos/hetzner.nix
    ../../modules/services/stalwart.nix
  ];

  networking.hostName = "server-mail";

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 2048;
    }
  ];

  networking.firewall.allowedTCPPorts = [
    25
    143
    443
    465
    587
    993
    4190
  ];

  system.stateVersion = "26.05";
}
