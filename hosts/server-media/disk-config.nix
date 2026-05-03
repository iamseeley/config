# Replace REPLACE_ME_INTERNAL and REPLACE_ME_EXTERNAL with stable
# /dev/disk/by-id/* paths from the target. On the booted installer:
#   lsblk -d -o NAME,SIZE,MODEL,TRAN
#   ls -la /dev/disk/by-id/
{ ... }: {
  disko.devices = {
    disk = {
      internal = {
        type = "disk";
        device = "REPLACE_ME_INTERNAL";
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
      external = {
        type = "disk";
        device = "REPLACE_ME_EXTERNAL";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/data";
                mountOptions = [ "defaults" "nofail" ];
              };
            };
          };
        };
      };
    };
  };
}
