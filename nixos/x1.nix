{ config, pkgs, ... }:
{
  imports = [
      ./hardware-x1.nix
      (import ./configuration.nix { hostname = "tokio"; config = config; pkgs = pkgs; })
  ];
  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];
  services.fwupd.enable = true;
  # For thinkpad
  services.tlp.enable = true;
}
