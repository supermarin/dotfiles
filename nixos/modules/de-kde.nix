{ pkgs, lib, ... }:
{
  imports = [ ./fonts.nix ];

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-all;
  environment.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    oxygen
  ];
}
