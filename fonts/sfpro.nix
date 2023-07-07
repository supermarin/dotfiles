{ pkgs }:

pkgs.stdenvNoCC.mkDerivation rec {
  buildInputs = [ pkgs._7zz ];
  name = "San Francisco";
  src = builtins.fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
    sha256 = "sha256:0z3cbaq9dk8dagjh3wy20cl2j48lqdn9q67lbqmrrkckiahr1xw3";
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


