{ inputs, config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
    ./media-stack.nix
    ../../modules/nixos/base.nix
  ];

  networking.hostName = "server-media";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  users.users.tseeley = {
    extraGroups = [ "networkmanager" ];
    initialHashedPassword = "$6$gNYfOkd1NbzTmNsS$EK7.21b8q66oq.2iIyTX8V.DpWMqJE9rjMpdu7USyoGWOrKTR06lH76NwpTHlwGrUCNvFhjRHJu9h8DxI57l2/";
  };

  # Keep the MacBook running with the lid closed (used as a server).
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchExternalPower = "ignore";
    lidSwitchDocked = "ignore";
  };

  system.stateVersion = "24.11";
}
