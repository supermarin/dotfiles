{ pkgs, ... }:
{
  imports = [
    ./de-common.nix
    ./fonts.nix
  ];

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.variables = {
    GNOME_SHELL_SLOWDOWN_FACTOR = "0.4"; # speed up animations
  };
  environment.systemPackages = with pkgs; [
    cantarell-fonts
    adwaita-icon-theme
    gnome-tweaks
    gnomeExtensions.tailscale-qs
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
