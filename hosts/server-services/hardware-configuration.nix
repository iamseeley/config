{ config, lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.initrd.availableKernelModules = [ "virtio_pci" "virtio_scsi" ];
  fileSystems."/" = { device = "/dev/sda2"; fsType = "ext4"; };
  fileSystems."/boot" = { device = "/dev/sda1"; fsType = "vfat"; };
}
