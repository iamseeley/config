{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim git curl htop docker-compose
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };

  networking.useDHCP = false;
  systemd.network.enable = true;
  systemd.network.networks."10-wan" = {
    matchConfig.Name = [ "en*" "eth*" ];
    networkConfig.DHCP = "ipv4";
  };
}
