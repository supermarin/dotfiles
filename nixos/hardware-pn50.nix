{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "nvme"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "rtsx_usb_sdmmc"
  ];
  boot.initrd.luks.devices.cryptroot.device =
    "/dev/disk/by-uuid/671c146e-1a13-47a8-89c4-bcf8918deef8";
  # This could not boot
  # boot.initrd.luks.devices.cryptroot.device = "/dev/mapper/cryptroot";
  boot.kernelModules = [ "kvm-amd" ];
  # TODO: add ssh in initrd and enable headless LUKS + secrets decrypting
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    memtest86.enable = true;
    useOSProber = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/00e8554d-251c-4884-9a67-c9ff934eb6fa";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B0FA-4FCB";
    fsType = "vfat";
  };

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
}
