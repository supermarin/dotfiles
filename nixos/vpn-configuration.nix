{ pkgs, modulesPath, ... }:
let
  networkInterface = "ens3";
in
{
  imports = [ (modulesPath + "/virtualisation/digital-ocean-config.nix") ];
  virtualisation.digitalOcean.setSshKeys = false;

  swapDevices = [{ device = "/swapfile"; size = 2048; }];
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPx9yl0N1u8n7nO3uZilfOGa/MtyFTfHsEgs8MDGAnAL supermarin@tokio" # tokio
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHEStWVGTSqu2acHbyOaiDfMvnzg5AGi7FtZOQrbG7gB git@mar.in" # simba
    ];
  };
  networking = {
    hostName = "vpn";
    nat.enable = true;
    nat.externalInterface = networkInterface;
    nat.internalInterfaces = [ "wg0" ];
    firewall = {
      allowedTCPPorts = [ 
          53 # dns
          22 # ssh
      ];
      allowedUDPPorts = [ 
          53 # dns
          51820 # wireguard
      ];
      interfaces.wg0.allowedTCPPorts = [ 
        # 8052 # wallabag. Looks like podman automaticallly exposes this
        8053 # pi-hole
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
          { # simba
            publicKey = "1IhkeEMG1rBmUq3tg3st9lUmNBHC+yrGmCzC1QOwW2Q=";
            allowedIPs = [ "10.100.0.2/32" ];
          }
          { # pixel
            publicKey = "QyWh7GoD4YKQZ3BYR2/Gmn79pTOR/IHWQLPHbIzpvAU=";
            allowedIPs = [ "10.100.0.3/32" ];
          }
          { # tokio
            publicKey = "9zlfIRmvON2kTh1zi8A/xOfP9LSRGWX/SE3GC+8VDgQ=";
            allowedIPs = [ "10.100.0.4/32" ];
          }
          { # boox
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
      ports = [ "10.100.0.1:8052:80" ];
      environment = {
        SYMFONY__ENV__DOMAIN_NAME = "http://10.100.0.1:8052";
        SYMFONY__ENV__FOSUSER_CONFIRMATION = "false";
        SERVER_PORT = "8052";
      };
    };
    pi-hole = {
      image = "pihole/pihole:2022.11.2";
      volumes = [
        "pihole:/etc/pihole"
        # locally resolves to
        # /var/lib/containers/storage/volumes/dnsmasq
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
