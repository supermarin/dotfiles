{ config, nixpkgs, pkgs, secrets, ... }:
{
  # Fix NetworkManager.wait-online.service bug
  # TODO: remove when dis resolves https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = pkgs.lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = pkgs.lib.mkForce false;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };

  services.fwupd.enable = true;
  services.udisks2.enable = true; # needed for fwupdmgr -.-
  services.yubikey-agent.enable = true;
  services.pcscd.enable = true;

  time.timeZone = "America/New_York";

  networking = {
    firewall = secrets.firewall.pumba;
    hostName = "pumba";
    networkmanager.enable = true;
  };

  services.tailscale.enable = true;
  # create a oneshot job to authenticate to Tailscale
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscaled.service" ];
    wants = [ "network-pre.target" "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey ${secrets.tailscale.pumba.authkey}
    '';
  };

  services.syncthing = secrets.syncthing "pumba" // {
    extraOptions.options.gui.enabled = false;
    user = "marin";
  };

  services.openssh.enable = true;
  programs.ssh.startAgent = true;
  programs.fish.enable = true;

  users.users.marin = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = import ../ssh/pubkeys.nix;
  };

  security.sudo.wheelNeedsPassword = false;
  environment.sessionVariables = {
    EDITOR = "vim";
    XKB_DEFAULT_OPTIONS = "ctrl:nocaps";
  };

  # Only put system software in here, e.g. stuff that is installed by
  # default on macOS and Ubuntu. The user software goes in home.nix.
  environment.systemPackages = with pkgs; [
    alacritty
    duckdb
    file # file(1)
    git
    htop
    jq
    killall # killall(1)
    (neovim.override { viAlias = true; vimAlias = true; })
    ripgrep
    sqlite-interactive
    tmux
    unzip
    zip
  ];

  nixpkgs.config.allowUnfree = true;
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
    registry.nixpkgs.flake = nixpkgs;
    settings = {
      trusted-users = [ "marin" "supermarin" ]; # enable nix-copy-closure
    };
  };

  system.stateVersion = "21.05";
}

