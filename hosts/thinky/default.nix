{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/server.nix
    ../../modules/services/caddy.nix
    ../../modules/services/miniflux.nix
    ../../modules/services/shaarli.nix
  ];

  networking.hostName = "thinky";
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  system.stateVersion = "25.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;
}
