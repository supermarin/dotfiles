{ pkgs, ... }:
{
  imports = [
    ./fonts.nix
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.variables = {
    GNOME_SHELL_SLOWDOWN_FACTOR = "0.4"; # speed up animations
  };
  environment.systemPackages = with pkgs; [
    cantarell-fonts
    adwaita-icon-theme
    gnome-tweaks
    gnomeExtensions.tailscale-qs
    wl-clipboard # wl-copy, wl-paste
  ];
  environment.gnome.excludePackages = (
    with pkgs;
    [
      atomix # puzzle game
      cheese # webcam tool
      epiphany # web browser
      geary # email reader
      gnome-photos
      gnome-terminal
      gnome-tour
      hitori # sudoku game
      iagno # go game
      tali # poker game
    ]
  );
}
