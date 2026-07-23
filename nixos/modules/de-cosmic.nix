{
  imports = [
    ./de-common.nix
    ./fonts.nix
  ];
  services.desktopManager.cosmic.enable = true;
  services.system76-scheduler.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
}
