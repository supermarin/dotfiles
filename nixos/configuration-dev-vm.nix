{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [ ./modules/fonts.nix ];

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
    (neovim.override {
      viAlias = true;
      vimAlias = true;
    })
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
  programs.dconf.enable = true;
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
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
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

  services.yubikey-agent.enable = true;
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    enable = true;
    dpi = 218;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status
        rofi
        xsel
      ];
    };
  };
}
