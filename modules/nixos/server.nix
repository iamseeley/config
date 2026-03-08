{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim git curl htop docker-compose
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };

  networking.useDHCP = false;
  systemd.network.enable = true;
  systemd.network.networks."10-wan" = {
    matchConfig.Name = "ens3";
    networkConfig.DHCP = "ipv4";
  };
}
