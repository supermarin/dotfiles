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
  # TODO: power-profiles-daemon and tlp clash. Figure out how to do 80% battery thing without TLP
  services.tlp = lib.mkIf (config.services.power-profiles-daemon.enable != true) {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 100;

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

    };
  };
  services.upower.enable = true;
}
