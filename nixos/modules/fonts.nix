{ inputs, pkgs, ... }: {
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      (import ../../fonts/sfpro.nix { inherit pkgs; }) # sans serif
      (import ../../fonts/sfmono.nix { inherit pkgs; }) # mono for browser
      (import ../../fonts/newyork.nix { inherit pkgs; }) # mono for browser
      inputs.fonts.packages.${pkgs.system}.berkeley-mono-slash-dot-normal-seven-normal
      inputs.fonts.packages.${pkgs.system}.berkeley-mono-slash-dot-normal-seven-semi-condensed
      inputs.fonts.packages.${pkgs.system}.berkeley-mono-slash-dot-normal-seven-condensed
      source-serif # serif

      noto-fonts-emoji # emoji
      font-awesome # i3status-rust

      hack-font # more mono ftw
      ibm-plex # more mono ftw
      iosevka # more mono ftw
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
