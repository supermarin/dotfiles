{ pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/virtualisation/digital-ocean-config.nix") ];
  virtualisation.digitalOcean.setSshKeys = false;

  swapDevices = [{ device = "/swapfile"; size = 2048; }];
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPx9yl0N1u8n7nO3uZilfOGa/MtyFTfHsEgs8MDGAnAL supermarin@tokio"
      # TODO: add simba's key
    ];
  };
  networking = {
    hostName = "vpn";
    nat.enable = true;
    nat.externalInterface = "eth0";
    nat.internalInterfaces = [ "wg0" ];
    firewall = {
      allowedUDPPorts = [ 51820 ];
    };
    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.100.0.1/24" ];
        listenPort = 51820;
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
        '';
        privateKeyFile = "/wireguard/private";
        peers = [
          { # simba
            publicKey = "BS2HfRpD+zcj4ZFuaM1EGHOZGS/SFtuKOxjy8d6hK3g=";
            allowedIPs = [ "10.100.0.2/32" ];
          }
          { # pixel
            publicKey = "BS2HfRpD+zcj4ZFuaM1EGHOZGS/SFtuKOxjy8d6hK3g=";
            allowedIPs = [ "10.100.0.3/32" ];
          }
          { # tokio
            publicKey = "9zlfIRmvON2kTh1zi8A/xOfP9LSRGWX/SE3GC+8VDgQ=";
            allowedIPs = [ "10.100.0.4/32" ];
          }
        ];
      };
    };
  };
}
