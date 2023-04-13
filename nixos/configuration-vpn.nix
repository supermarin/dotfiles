{ pkgs, modulesPath, secrets, ... }:
let
  networkInterface = "eth0";
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.openssh.enable = true;
  users.users.root = {
    openssh.authorizedKeys.keys = import ../ssh/pubkeys.nix;
  };

  networking = {
    enableIPv6 = false;
    useDHCP = false;
    hostName = "vpn";
    nat.enable = true;
    nat.externalInterface = networkInterface;
    nat.internalInterfaces = [ "tailscale0" ];
    usePredictableInterfaceNames = false;
    interfaces.eth0.useDHCP = true;
    firewall = {
      checkReversePath = "loose"; # for Tailscale
      allowedTCPPorts = [
      ];
      allowedUDPPorts = [
        51820 # wireguard
      ];
      interfaces.tailscale0.allowedTCPPorts = [
        8052 # wallabag
        8053 # pi-hole
        53 # dns
        22 # ssh
      ];
      interfaces.tailscale0.allowedUDPPorts = [
        53 # dns
      ];
    };
  };

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "server";
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
      ${tailscale}/bin/tailscale up -authkey ${secrets.tailscale.vpn.authkey} --advertise-exit-node
    '';
  };

  virtualisation.oci-containers.containers = {
    wallabag = {
      image = "wallabag/wallabag";
      volumes = [
        "wallabag-data:/var/www/wallabag/data"
        "wallabag-images:/var/www/wallabag/web/assets/images"
      ];
      # TODO: let's see if this can be removed and port manually exposed in networking.
      # ports = [ "10.100.0.1:8052:80" ];
      environment = {
        SYMFONY__ENV__DOMAIN_NAME = "http://10.100.0.1:8052";
        SYMFONY__ENV__FOSUSER_CONFIRMATION = "false";
        PORT = "8052";
      };
    };
    pi-hole = {
      image = "pihole/pihole:2022.12";
      volumes = [
        "pihole:/etc/pihole"
        "dnsmasq:/etc/dnsmasq.d"
      ];
      extraOptions = [
        "--network=host"
      ];
      environment = {
        WEB_PORT = "8053";
      };
    };
  };
  system.stateVersion = "22.05";
}
