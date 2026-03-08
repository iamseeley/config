{ inputs, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/server.nix
    ../../modules/services/stalwart.nix
  ];

  networking.hostName = "server-mail";

  networking.firewall.allowedTCPPorts = [
    25 80 110 143 443 465 587 993 995 4190 8080
  ];

  system.stateVersion = "24.11";
}
