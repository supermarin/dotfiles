{ inputs, config, pkgs, berkeley, ... }:
{
  imports = [ ./fonts.nix ];

  environment.sessionVariables = {
    EDITOR = "vim";
    XKB_DEFAULT_OPTIONS = "ctrl:nocaps";
  };
  environment.systemPackages = with pkgs; [
    direnv
    duckdb
    file # file(1)
    git
    git-lfs
    btop
    jq
    killall # killall(1)
    nbstripout
    (neovim.override { viAlias = true; vimAlias = true; })
    ripgrep
    sqlite-interactive
    tmux
    unzip
    zip

    pcscliteWithPolkit.out # fix pcscd. TODO: remove when https://github.com/NixOS/nixpkgs/issues/280826 is closed
  ];
  networking = {
    firewall = {
      allowedUDPPorts = [
        config.services.tailscale.port
      ];
      interfaces.tailscale0 = {
        allowedTCPPorts = [
          # 5900 # paper VNC
        ];
      };
      trustedInterfaces = [ "tailscale0" ];
    };
    networkmanager.enable = true; # TODO: see if we can nuke this
  };
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "monthly";
    };
    optimise = {
      automatic = true;
      dates = [ "monthly" ];
    };
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings = {
      trusted-users = [ "marin" ]; # enable nix-copy-closure
    };
  };
  programs.fish.enable = true;
  security.sudo.wheelNeedsPassword = false;
  services.openssh.enable = true; # Enable remote login
  services.fwupd.enable = true;
  services.pcscd-keep-alive.enable = true;
  services.udisks2.enable = true; # needed for fwupdmgr -.-
  services.tailscale.enable = true;
  time.timeZone = "America/New_York";

  users.users.marin = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/supermarin.keys";
        sha256 = "sha256:1agzynmgixan6pj46s5q4ygg8yknh9phm4vlhx7ppy72b0a8fxyx";
      })
    ];
  };
  virtualisation.podman = {
    enable = true;
  };
  virtualisation.oci-containers.backend = "podman";



  ##############################################################################
  # DE - delete
  ##############################################################################
  hardware.bluetooth.enable = true; # enables bluez
  hardware.pulseaudio.enable = false; # pipewire instead
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  services.yubikey-agent.enable = true;

  # only for sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
    extraPackages = with pkgs; [
      blueberry # Bluetooth devices management gui
      brightnessctl # Brightness control
      grim # wayland screenshot tool
      i3status-rust # Menu bar
      libnotify # notify-send
      swaynotificationcenter # notification daemon
      mupdf
      gedit # basic text file opener
      gnome.gnome-calculator
      gnome.nautilus # gui file browser
      gnome.sushi # quick preview for nautilus
      playerctl # media keys (play/pause, prev, next)
      pavucontrol # select sound output device
      rofi-wayland
      rofimoji # emoji picker, fuzzel doesn't support emoji
      slurp # screenshot: select a region in wayland
      swaylock # idle lock
      swayidle # idle lock
      udiskie # auto mount usb media
      xdg-utils
      w3m # for HTML emails
      wdisplays
      wl-clipboard # wl-copy, wl-paste
      wob # indicator bar
    ];
    extraSessionCommands = ''
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    '';
  };
}
  // {
  ##############################################################################
  # BUG FIXES - remove as upstream is fixed
  ##############################################################################
  # Fix NetworkManager.wait-online.service bug
  # TODO: remove when dis resolves https://github.com/NixOS/nixpkgs/issues/180175
  # It seems like this happens only in tandem with tailscale?
  systemd.services.NetworkManager-wait-online.enable = pkgs.lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = pkgs.lib.mkForce false;
}
