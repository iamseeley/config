{ inputs, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    ./media-stack.nix
    ../../modules/nixos/base.nix
  ];

  networking.hostName = "server-media";
  networking.useDHCP = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}
