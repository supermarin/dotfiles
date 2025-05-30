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
      font-awesome # i3status-rust

      # monospace
      hack-font
      ibm-plex
      inputs.fonts.packages.${pkgs.system}.berkeley-mono-slash-dot-normal-seven-condensed
      inputs.fonts.packages.${pkgs.system}.berkeley-mono-slash-dot-normal-seven-normal
      inputs.fonts.packages.${pkgs.system}.berkeley-mono-slash-dot-normal-seven-semi-condensed
      iosevka
      monaspace
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
