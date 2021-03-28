{ config, pkgs, ... }:
{
  imports = [
      ./hardware-x1.nix
      (import ./configuration.nix { hostname = "pumba"; config = config; pkgs = pkgs; })
  ];
}
