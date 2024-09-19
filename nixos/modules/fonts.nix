{ inputs, pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      (import ../../fonts/sfpro.nix { inherit pkgs; }) # sans serif
      (import ../../fonts/sfmono.nix { inherit pkgs; }) # mono for browser
      (import ../../fonts/newyork.nix { inherit pkgs; }) # mono for browser
      (import inputs.fonts { inherit pkgs; }) # berkeley mono
      source-serif # serif

      noto-fonts-emoji # emoji
      font-awesome # i3status-rust

      ibm-plex # more mono ftw
      iosevka # more mono ftw
      hack-font # more mono ftw
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "New York" ];
        sansSerif = [ "SF Pro Display" ];
        monospace = [ "Berkeley Mono" ];
        emoji = [ "Noto" ];
      };
    };
  };
}
