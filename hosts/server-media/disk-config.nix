# Single-disk install on external 1TB LaCie Rugged USB-C HDD.
{
  disko.devices.disk.main = {
    type = "disk";
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
            extraArgs = [
              "-L"
              "media"
            ];
            mountpoint = "/";
          };
        };
      };
    };
  };
}
