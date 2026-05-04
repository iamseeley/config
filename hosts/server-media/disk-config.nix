# Single-disk install on external 1TB LaCie Rugged USB-C HDD.
# Internal SSDs on the target MacBook are inaccessible (T2 lockout / hw issue).
{
  disko.devices.disk.main = {
    type = "disk";
    # LaCie Rugged USB-C 1TB HDD (single-disk install).
    device = "/dev/disk/by-id/usb-LaCie_Rugged_USB-C_0000NT159P7X-0:0";
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
            extraArgs = [ "-L" "media" ];
            mountpoint = "/";
          };
        };
      };
    };
  };
}
