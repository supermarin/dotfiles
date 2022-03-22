{ pkgs, lib, ... }:
{
  # anything macos specific to install 
  environment.systemPackages = [];
  networking.hostName = "simba";

  users.users.supermarin.home = /Users/supermarin;

  # macOS defaults
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.dock.orientation = "right";
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  nix.useDaemon = true;
  # nix.registry.nixpkgs.flake = nixpkgs;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
}
