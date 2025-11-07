{ inputs, pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      # sans
      (import ../../fonts/sfpro.nix { inherit pkgs; })
      (import ../../fonts/inter-head.nix { inherit pkgs; })
      noto-fonts-cjk-sans

      # serif
      source-serif
      eb-garamond
      (import ../../fonts/newyork.nix { inherit pkgs; })
      noto-fonts-cjk-serif

      # emoji
      noto-fonts-color-emoji

      # monospace
      inputs.fonts.packages.${pkgs.system}.berkeley-mono.condensed
      inputs.fonts.packages.${pkgs.system}.berkeley-mono.normal
      inputs.fonts.packages.${pkgs.system}.berkeley-mono.semi-condensed
      iosevka
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "New York Medium" ];
        sansSerif = [ "SF Pro Display" ];
        monospace = [ "Berkeley Mono" ];
        emoji = [ "Noto" ];
      };
    };
  };
}
