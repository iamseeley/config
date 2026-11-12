{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/server.nix
    ../../modules/services/miniflux.nix
    ../../modules/services/shaarli.nix
  ];

  networking.hostName = "thinky";

  # the NixOS release this machine was installed with; never bump it
  system.stateVersion = "25.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;
}
