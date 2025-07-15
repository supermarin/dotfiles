{ inputs, pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      # sans serif
      (import ../../fonts/sfpro.nix { inherit pkgs; })
      (import ../../fonts/inter-head.nix { inherit pkgs; })

      # serif
      source-serif
      eb-garamond
      (import ../../fonts/newyork.nix { inherit pkgs; })

      # emoji
      noto-fonts-emoji

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
