# Single-disk install on external USB drive (OWC enclosure, 1TB Toshiba HDD).
# Internal SSDs on the target MacBook are inaccessible (T2 lockout / hw issue).
{ ... }: {
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/usb-OWC_On-The-Go_Pro_002932004735-0:0";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
