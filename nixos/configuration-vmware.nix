{ inputs, config, pkgs, secrets, ... }:
{
  imports = [ ./modules/fonts.nix ];

  virtualisation.vmware.guest.enable = true;
  time.timeZone = "America/New_York";

  networking = {
    firewall = secrets.firewall.tokio;
    hostName = "tokio-vm";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    networkmanager.enable = true;
  };

  programs.fish.enable = true;
  services.openssh.enable = true;
  services.getty.autologinUser = "marin";
  services.tailscale.enable = true;

  users.users.marin = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = import ../ssh/pubkeys.nix;
  };

  environment.sessionVariables = {
    EDITOR = "vim";
    XKB_DEFAULT_OPTIONS = "ctrl:nocaps";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/yubikey-agent/yubikey-agent.sock";
  };

  environment.systemPackages = with pkgs; [
    dig
    file # file(1)
    killall # killall(1)
    unzip
    zip
  ];
}

