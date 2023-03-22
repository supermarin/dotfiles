# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
#
# Future me: already made changes here esp after moving to flakes -.-
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.luks.devices.cryptroot.device = "/dev/disk/by-uuid/b40ce794-595a-4057-a7bf-61a4a0e4371f";
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a8b013cc-3a89-410c-9e1f-e8086b304f74";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/FE77-508B";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/1f3fc21a-3780-4f6a-a8ec-691fb9070e6b"; }
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave"; # TODO: should we remove this?
}
