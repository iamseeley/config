{ config, pkgs, ... }: {
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking.useDHCP = false;
  systemd.network.enable = true;
  systemd.network.networks."10-wan" = {
    matchConfig.Name = [ "en*" "eth*" ];
    networkConfig.DHCP = "ipv4";
  };
}
