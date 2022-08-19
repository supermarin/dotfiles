{ pkgs, lib, config, ... }:
{
  networking.hostName = "simba";
  environment.shells = [ pkgs.bashInteractive pkgs.fish ];
  environment.loginShell = "${pkgs.bashInteractive} -l";
  environment.loginShellInit = "exec fish";

  users.users.supermarin = {
    home = "/Users/supermarin"; # important for home-manager
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

  launchd.user.agents.syncthing = {
    environment = {
      STNORESTART = "1";
    };
    command = "${pkgs.syncthing}/bin/syncthing";
    serviceConfig = {
      ProcessType = "Background";
      LowPriorityIO = true;
      KeepAlive = true;
      Label = "net.syncthing.syncthing";
    };
  };

  nix.useDaemon = true;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  nixpkgs.config.allowUnfree = true; # Obsidian needs this ATM

  # Unfuck ~/Applications
  system.activationScripts.applications.text = pkgs.lib.mkForce (
    ''
      echo "[CUSTOM][darwin.nix] setting up ~/Applications..." >&2
      rm -rf ~/Applications/Nix\ Apps
      mkdir -p ~/Applications/Nix\ Apps
      for app in $(find ${config.system.build.applications}/Applications -maxdepth 1 -type l); do
        src="$(/usr/bin/stat -f%Y "$app")"
        cp -r "$src" ~/Applications/Nix\ Apps
      done
    ''
  );
}
