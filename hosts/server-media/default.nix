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
    ./media-stack.nix
    ./vpn-namespace.nix
    ../../profiles/server.nix
  ];

  networking.hostName = "server-media";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  age.secrets.tailscale-authkey.file = ../../secrets/tailscale-authkey.age;

  users.users.tseeley = {
    extraGroups = [ "networkmanager" ];
    initialHashedPassword = "$6$gNYfOkd1NbzTmNsS$EK7.21b8q66oq.2iIyTX8V.DpWMqJE9rjMpdu7USyoGWOrKTR06lH76NwpTHlwGrUCNvFhjRHJu9h8DxI57l2/";
  };

  services.logind = {
    lidSwitch = "ignore";
    lidSwitchExternalPower = "ignore";
    lidSwitchDocked = "ignore";
  };

  system.stateVersion = "24.11";
}
