{ inputs, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/hyprland.nix
  ];

  networking.hostName = "personal-laptop";
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.docker.enable = true;
  users.users.tseeley.extraGroups = [ "docker" ];

  services.tailscale.enable = true;

  services.syncthing = {
    enable = true;
    user = "tseeley";
    dataDir = "/home/tseeley";
  };

  home-manager.users.tseeley.imports = [
    ../../home/dev.nix
    ../../home/ssh.nix
    ../../home/scripts.nix
    ../../home/neovim
    ../../home/apps.nix
    ../../home/alacritty.nix
    ../../home/ghostty.nix
    ../../home/tmux.nix
  ];

  system.stateVersion = "24.11";
}
