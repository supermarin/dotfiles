{ config, pkgs, ... }:
{
  environment.sessionVariables = {
    EDITOR = "vim";
    XKB_DEFAULT_OPTIONS = "ctrl:nocaps";
  };
  environment.systemPackages = with pkgs; [
    duckdb
    file # file(1)
    git
    git-lfs
    jq
    killall # killall(1)
    (neovim.override {
      viAlias = true;
      vimAlias = true;
    })
    ripgrep
    sqlite-interactive
  ];
  networking = {
    firewall = {
      allowedUDPPorts = [
        config.services.tailscale.port
      ];
      interfaces.tailscale0.allowedTCPPorts = [
        22
        80
      ];
      trustedInterfaces = [ "tailscale0" ];
    };
    networkmanager.enable = true; # TODO: see if we can nuke this
  };

  services.caddy = {
    enable = true;
    virtualHosts.":80".extraConfig = ''
      reverse_proxy /health/* 127.0.0.1:${builtins.toString config.services.grafana.settings.server.http_port}
    '';
  };

  # TODO: remove and only use tailscale ssh?
  #       figure out if either ssh or ts will go into initramfs
  services.openssh.enable = true; # Enable remote login
  services.fwupd.enable = true;
  services.udisks2.enable = true; # needed for fwupdmgr -.-
  services.tailscale.enable = true;
  time.timeZone = "America/New_York";
  users.users.marin = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/supermarin.keys";
        sha256 = "sha256:11nl0mc2yb040y6bcwzj73sflav9273b50ic1ljbkb0mpl75xn0g";
      })
    ];
  };
}
