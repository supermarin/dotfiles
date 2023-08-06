{ pkgs }:

pkgs.stdenvNoCC.mkDerivation rec {
  buildInputs = [ pkgs._7zz ];
  name = "San Francisco";
  src = builtins.fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
    sha256 = "sha256:19qa6fs6x5614sqw9a6idlizzsssw8256crz1ps2p2n6gwp2fvaq";
  };
  unpackPhase = ''
    7zz x $src
    7zz x "SFProFonts/SF Pro Fonts.pkg"
    7zz x "Payload~" -oSFPro
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/opentype
    cp SFPro/Library/Fonts/*.otf $out/share/fonts/opentype
    runHook postInstall
  '';
}


