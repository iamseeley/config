{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    ../../modules/nixos/server.nix
    ../../modules/nixos/hetzner.nix
    ../../modules/services/stalwart.nix
  ];

  networking.hostName = "mail";

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

  # the NixOS release this machine was installed with; never bump it
  system.stateVersion = "26.05";
}
