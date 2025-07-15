{ pkgs, lib, ... }:
{
  imports = [ ./fonts.nix ];

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-all;
  programs.ssh.startAgent = true;
  environment.systemPackages = with pkgs; [
    ddcutil # another brightness control. for ext displays via i2c
    kdePackages.ghostwriter
    kdePackages.kcalc
    kdePackages.kcontacts
    kdePackages.merkuro

    wl-clipboard
  ];
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    oxygen
  ];
}
