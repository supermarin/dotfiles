{ config, pkgs, ... }:
{
  imports = [
      ./hardware-x1.nix
      (import ./configuration.nix { hostname = "tokio"; config = config; pkgs = pkgs; })
  ];
}
