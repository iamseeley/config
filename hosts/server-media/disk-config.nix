# Single-disk install on external 1TB LaCie SSD via USB.
# Internal SSDs on the target MacBook are inaccessible (T2 lockout / hw issue).
{
  disko.devices.disk.main = {
    type = "disk";
    # LaCie 1TB SSD via USB.
    # TODO: replace with the actual /dev/disk/by-id/usb-LaCie_... path
    # from `ls -la /dev/disk/by-id/` on the target with the LaCie plugged in.
    device = "REPLACE_ME_LACIE";
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
