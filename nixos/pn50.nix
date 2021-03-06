# Usage:
#   $ ln -s $0 /etc/nixos/configuration.nix
# Then just normally
#   $ nixos-rebuild switch

{ config, pkgs, ... }:
{
  imports = [
      ./hardware-pn50.nix
      (import ./configuration.nix { hostname = "pumba"; config = config; pkgs = pkgs; })
  ];
}
