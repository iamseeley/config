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
