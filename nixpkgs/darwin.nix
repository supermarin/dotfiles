{ config, pkgs, ... }:

{
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin.nix";
  environment.variables = {
    EDITOR = "vim";
  };
  environment.shells = with pkgs; [
    bashInteractive_5
    fish
  ];
  environment.systemPackages = with pkgs; [ 
    home-manager
    vim
    git
  ];

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.fish.enable = true;

  users.users.supermarin = {
    shell = pkgs.fish;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;
}
