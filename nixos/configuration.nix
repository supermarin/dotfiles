{ pkgs, config, ... }:
{
  # Fix NetworkManager.wait-online.service bug
  # TODO: remove when dis resolves https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = pkgs.lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = pkgs.lib.mkForce false;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hardware.bluetooth.enable = true; # enables bluez
  hardware.pulseaudio.enable = false; # pipewire instead
  sound.enable = true;
  time.timeZone = "America/New_York";

  networking = {
    extraHosts = builtins.readFile (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
      sha256 = "sha256:0ydcxxxhxhalnifr323wnvysjnp65hxhlrzvzzghlm2ja9d1z448";
    });
    firewall = {
      allowedTCPPorts = [ ];
      allowedUDPPorts = [
        config.services.tailscale.port
      ];
      trustedInterfaces = [ "tailscale0" ];
    };
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    networkmanager.enable = true;
  };
  programs.fish.enable = true;

  # needed for printer discovery on the network
  services.avahi = {
    enable = true;
    publish.enable = true;
    publish.workstation = true;
    publish.addresses = true;
    nssmdns4 = true;
  };
  services.fwupd.enable = true;
  services.openssh.enable = true;
  services.pcscd-keep-alive.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  services.printing.enable = true; # TODO: test if we need this anymore?
  services.tailscale.enable = true;
  services.udisks2.enable = true; # needed for fwupdmgr -.-
  services.udev.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="043e", ATTRS{idProduct}=="9a40", MODE="0666"
  '' # LG Ultrafine 5K (9a40)
  + ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="9243", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="1114", MODE="0666"
  '' # Pro Display XDR (9243) & Studio Display (1114)
  ;

  services.yubikey-agent.enable = true;

  users.users.marin = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
    openssh.authorizedKeys.keyFiles = [ ../ssh/pubkeys.nix ];
  };

  environment.sessionVariables = {
    EDITOR = "vim";
    QT_QPA_PLATFORM = "wayland"; # TODO: check if still needed, electron fucked
    XKB_DEFAULT_OPTIONS = "ctrl:nocaps";
  };

  # Only put system software in here, e.g. stuff that is installed by
  # default on macOS and Ubuntu. The user software goes in home.nix.
  environment.systemPackages = with pkgs; [
    appimage-run # experimental
    dig
    file # file(1)
    killall # killall(1)
    libreoffice
    unzip
    virt-manager
    zip

    pcscliteWithPolkit.out # fix pcscd. TODO: remove when https://github.com/NixOS/nixpkgs/issues/280826 is closed
  ];

  # Virtualisation
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.podman = {
    enable = true;
  };
}
