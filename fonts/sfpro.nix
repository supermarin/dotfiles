{ pkgs }:

pkgs.stdenvNoCC.mkDerivation rec {
  buildInputs = [ pkgs._7zz ];
  name = "San Francisco";
  src = builtins.fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
    sha256 = "sha256-g/eQoYqTzZwrXvQYnGzDFBEpKAPC8wHlUw3NlrBabHw=";
  };
  unpackPhase = ''
    7zz x $src
    7zz x "SFProFonts/SF Pro Fonts.pkg"
    7zz x "Payload~" -oSFPro
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/opentype
    ls -lah SFPro/
    cp SFPro/Library/Fonts/*.otf $out/share/fonts/opentype
    runHook postInstall
  '';
}
