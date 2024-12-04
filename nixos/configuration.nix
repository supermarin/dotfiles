{ inputs, pkgs, config, ... }:
{
  imports = [
    inputs.lix.nixosModules.default
    inputs.pcscd-keep-alive.nixosModules.pcscd-keep-alive
    inputs.steven-black-hosts.nixosModule
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
    tree
    unzip
    virt-manager
    zip

    pcscliteWithPolkit.out # fix pcscd. TODO: remove when https://github.com/NixOS/nixpkgs/issues/280826 is closed
  ];

  hardware.bluetooth = {
    enable = true; # enables bluez
  };
  hardware.pulseaudio.enable = false; # pipewire requires this disabled

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
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    networkmanager.enable = true;
    stevenBlackHosts.enable = true; 
  };
  programs.fish.enable = true;
  # programs.ssh.knownHosts = {
  #   nixbuild = {
  #     hostNames = [ "eu.nixbuild.net" ];
  #     publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
  #   };
  # };
  # programs.ssh.extraConfig = ''
  #   Host eu.nixbuild.net
  #   PubkeyAcceptedKeyTypes ssh-ed25519
  #   ServerAliveInterval 60
  #   IPQoS throughput
  #   IdentityFile /etc/ssh/ssh_host_ed25519_key
  # '';

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
  services.tailscale.permitCertUid = "caddy";
  services.udisks2.enable = true; # needed for fwupdmgr -.-
  services.udev.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="043e", ATTRS{idProduct}=="9a40", MODE="0666"
  '' # LG Ultrafine 5K (9a40)
  + ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="9243", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="1114", MODE="0666"
  '' # Pro Display XDR (9243) & Studio Display (1114)
  + ''
    SUBSYSTEM=="hidraw", KERNEL=="hidraw*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '' # TODO: add ATTRS{serial}=="*vial:whatever* or ATTRS{idProduct}" to limit nuphy keyboard only
  # 19f5:3247
#KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="100", TAG+="uaccess", TAG+="udev-acl"
  ;
  services.yubikey-agent.enable = true;
  # services.yubikey-agent.package = inputs.yubikey-agent.packages.${pkgs.stdenv.hostPlatform.system}.default;

  users.users.marin = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "podman" "docker" ];
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
