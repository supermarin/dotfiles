{ config, pkgs, ... }:

{
  users.users.supermarin = {
    shell = pkgs.bash;
  };

  # Darwin only below. TODO: move to separate file
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.dock.orientation = "right";
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin.nix";
}
