{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    inputs.lix.nixosModules.default
    inputs.steven-black-hosts.nixosModule
    inputs.pcscd-keep-alive.nixosModules.pcscd-keep-alive
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
  documentation.man.generateCaches = pkgs.lib.mkForce false; # otherwise nixos-rebuild is slow AF
  environment.sessionVariables = {
    EDITOR = "nvim";
    QT_QPA_PLATFORM = "wayland"; # TODO: check if still needed, electron fucked
    XKB_DEFAULT_OPTIONS = "ctrl:nocaps";
    NIXOS_OZONE_WL = "1"; # https://discourse.nixos.org/t/partly-overriding-a-desktop-entry/20743/2
  };

  # Only put system software in here, e.g. stuff that is installed by
  # default on macOS and Ubuntu. The user software goes in home.nix.
  environment.systemPackages = with pkgs; [
    appimage-run # experimental
    dig
    file # file(1)
    killall # killall(1)
    libreoffice
    tree
    unzip
    virt-manager
    zip

    pcscliteWithPolkit.out # fix pcscd. TODO: remove when https://github.com/NixOS/nixpkgs/issues/280826 is closed
  ];

  hardware.bluetooth = {
    enable = true; # enables bluez
  };

  networking = {
    # TODO: see if it makes more sense to use Blocky here
    extraHosts = builtins.readFile ./hosts.txt;
    firewall = {
      allowedTCPPorts = [ ];
      allowedUDPPorts = [
        config.services.tailscale.port
        22000 # syncthing
      ];
      trustedInterfaces = [ "tailscale0" ];
    };
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    networkmanager.enable = true;
    stevenBlackHosts.enable = true;
  };
  programs.ssh.startAgent = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };
  services.fwupd.enable = true;
  services.openssh.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  services.pcscd-keep-alive.enable = true;
  services.pulseaudio.enable = false; # pipewire requires this disabled
  services.printing.enable = true;
  services.tailscale.enable = true;
  services.tailscale.permitCertUid = "caddy";
  services.udev.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", KERNEL=="hidraw*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '' # TODO: add ATTRS{serial}=="*vial:whatever* or ATTRS{idProduct}" to limit nuphy keyboard only
  # 19f5:3247
  #KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="100", TAG+="uaccess", TAG+="udev-acl"
  ;
  services.udisks2.enable = true; # needed for fwupdmgr -.-
  services.yubikey-agent.enable = true;

  users.users.marin = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "podman"
      "docker"
    ];
    openssh.authorizedKeys.keyFiles = [ ../ssh/pubkeys.nix ];
  };

  # Virtualisation
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true; # ebable tpm 2.0 emulation
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };

  time.timeZone = "America/New_York";
}
