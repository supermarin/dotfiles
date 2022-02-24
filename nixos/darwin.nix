{ config, pkgs, ... }:
{
  imports = [
      (import "${builtins.fetchTarball 
        https://github.com/nix-community/home-manager/archive/a28cf79a78040b4e6d8d50a39760a296d5e95dd6.tar.gz}/nix-darwin")
  ];

  # anything macos specific to install 
  environment.systemPackages = [];
  networking.hostName = "simba";

  users.users.supermarin.home = /Users/supermarin; # important for home-manager
  home-manager.users.supermarin = {
    imports = [ ../home.nix ];
  };

  # macOS defaults
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.dock.orientation = "right";
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  # Auto upgrade nix package and the daemon service.
  nix.useDaemon = true;
  nix.package = pkgs.nix;
}
