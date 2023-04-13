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
    nat.internalInterfaces = [ "wg0" ];
    usePredictableInterfaceNames = false;
    interfaces.eth0.useDHCP = true;
    firewall = {
      allowedTCPPorts = [
      ];
      allowedUDPPorts = [
        51820 # wireguard
      ];
      interfaces.wg0.allowedTCPPorts = [
        8052 # wallabag
        8053 # pi-hole
        53 # dns
        22 # ssh
      ];
      interfaces.wg0.allowedUDPPorts = [
        53 # dns
      ];
    };
    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.100.0.1/24" ];
        listenPort = 51820;
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${networkInterface} -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${networkInterface} -j MASQUERADE
        '';
        privateKeyFile = "/wireguard/private";
        peers = [
          {
            # simba
            publicKey = "1IhkeEMG1rBmUq3tg3st9lUmNBHC+yrGmCzC1QOwW2Q=";
            allowedIPs = [ "10.100.0.2/32" ];
          }
          {
            # pixel
            publicKey = "QyWh7GoD4YKQZ3BYR2/Gmn79pTOR/IHWQLPHbIzpvAU=";
            allowedIPs = [ "10.100.0.3/32" ];
          }
          {
            # tokio
            publicKey = "9zlfIRmvON2kTh1zi8A/xOfP9LSRGWX/SE3GC+8VDgQ=";
            allowedIPs = [ "10.100.0.4/32" ];
          }
          {
            # boox
            publicKey = "DdbOf4jyx8AOGV7tFwUoszibrplRGB1lQPni16BzBGc=";
            allowedIPs = [ "10.100.0.5/32" ];
          }
        ];
      };
    };
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
