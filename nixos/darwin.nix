{ pkgs, lib, ... }:
{
  networking.hostName = "simba";
  environment.shells = [ pkgs.bashInteractive pkgs.fish ];
  environment.loginShell = "${pkgs.bashInteractive} -l";
  environment.loginShellInit = "exec fish";

  users.users.supermarin = {
    home = /Users/supermarin; # important for home-manager
    shell = pkgs.bashInteractive;
  };

  system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  system.defaults.NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true;

  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.QuitMenuItem = true;
  system.defaults.dock.autohide = true;
  system.defaults.dock.orientation = "right";

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  nix.useDaemon = true;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  nixpkgs.config.allowUnfree = true; # Obsidian needs this ATM
}
