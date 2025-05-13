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
  ];

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
  environment.pathsToLink = [ "/share/zsh" ]; # for zsh system completions

  # Only put system software in here, e.g. stuff that is installed by
  # default on macOS and Ubuntu. The user software goes in home.nix.
  environment.systemPackages = with pkgs; [
    appimage-run # experimental
    dig
    file # file(1)
    killall # killall(1)
    tree
    unzip
    zip
  ];

  hardware.bluetooth = {
    enable = true; # enables bluez
  };

  hardware.i2c.enable = true;

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
  services.pcscd.enable = true; # for yubikey
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  services.pulseaudio.enable = false; # pipewire requires this disabled
  services.printing.enable = true;
  services.tailscale.enable = true;
  services.tailscale.permitCertUid = "caddy";
  services.udev.enable = true;
  services.udev.extraRules =
    let
      kinesis = "29ea";
      adv360 = "0362";
      nuphy = "19f5";
      air75V2 = "3246";
    in
    ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="${nuphy}", ATTRS{idProduct}=="${air75V2}", TAG+="uaccess", MODE="0660", GROUP="users" 
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="${kinesis}", ATTRS{idProduct}=="${adv360}", TAG+="uaccess", MODE="0660", GROUP="users"
    '';
  services.udisks2.enable = true; # needed for fwupdmgr -.-

  users.users.marin = {
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true; # managed through HM. REMOVE IF CHANGING SH
    isNormalUser = true;
    extraGroups = [
      "docker"
      "i2c" # brightness
      "libvirtd"
      "networkmanager"
      "podman"
      "wheel"
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
