{ pkgs, modulesPath, secrets, ... }:
let
  networkInterface = "eth0";
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.kernelPackages = pkgs.linuxPackages_latest;

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

  virtualisation.oci-containers.containers = {
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
