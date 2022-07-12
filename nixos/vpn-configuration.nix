{ pkgs, modulesPath, ... }:
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
    nat.externalInterface = "ens3";
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
            publicKey = "8u+pT5OVrgWMo3TebulvnSkMRqy1VdQQ/9bm3LHLqU8=";
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
        ];
      };
    };
  };
}
