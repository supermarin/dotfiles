{
  inputs,
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-nano-gen1
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.luks.devices.cryptroot.device =
    "/dev/disk/by-uuid/b40ce794-595a-4057-a7bf-61a4a0e4371f";
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
    { device = "/dev/disk/by-label/swap"; }
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableRedistributableFirmware = true;
  services.power-profiles-daemon.enable = true;
  services.tlp.enable = lib.mkIf (config.services.power-profiles-daemon.enable != true) true;
  services.upower.enable = true;
}
