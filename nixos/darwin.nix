{ config, pkgs, ... }:
{
  imports = [
      (import "${builtins.fetchTarball 
        https://github.com/rycee/home-manager/archive/64607f58b75741470284c698f82f0199fcecdfa7.tar.gz}/nix-darwin")
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

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
