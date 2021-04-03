{ config, pkgs, ... }:
{
  imports = [
    <home-manager/nix-darwin>
  ];

  # anything macos specific to install 
  environment.systemPackages = [];
  environment.darwinConfig = "$HOME/dotfiles/nixos/darwin.nix";

  users.users.supermarin.home = /Users/supermarin; # important for home-manager
  home-manager.users.supermarin = {
    imports = [ ../home.nix ];
  };

  # default shell
  programs.fish.enable = true;

  # macOS defaults
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.dock.orientation = "right";
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
