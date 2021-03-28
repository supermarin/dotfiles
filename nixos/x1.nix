# Usage:
#   $ ln -s $0 /etc/nixos/configuration.nix
# Then just normally
#   $ nixos-rebuild switch

{ config, pkgs, ... }:
{
  imports = [
      ./hardware-x1.nix
      (import ./configuration.nix { hostname = "tokio"; config = config; pkgs = pkgs; })
  ];
}
