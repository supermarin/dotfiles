{ pkgs }:

pkgs.stdenvNoCC.mkDerivation {
  buildInputs = [ pkgs._7zz ];
  name = "San Francisco";
  src = builtins.fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
    sha256 = "sha256-090HwtgILtK/KGoOzcwz1iAtoiShKAVjiNhUDQtO+gQ=";
  };
  unpackPhase = ''
    7zz x $src
    7zz x "SFProFonts/SF Pro Fonts.pkg"
    7zz x SFProFonts.pkg/Payload -oSFPro
    7zz x SFPro/Payload~ -oSFPro
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/opentype
    cp SFPro/Library/Fonts/*.otf $out/share/fonts/opentype
    runHook postInstall
  '';
}
