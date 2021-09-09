{ config, pkgs, ... }:
{
  imports = [
      ./hardware-x1.nix
      (import ./configuration.nix { hostname = "tokio"; config = config; pkgs = pkgs; })
  ];
  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];
  # For thinkpad
  services.fwupd.enable = true;
}
