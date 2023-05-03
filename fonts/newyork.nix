{ pkgs }:

pkgs.stdenvNoCC.mkDerivation rec {
  buildInputs = [ pkgs._7zz ];
  name = "New York";
  src = builtins.fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/NY.dmg";
    sha256 = "sha256:1q0b741qiwv5305sm3scd9z2m91gdyaqzr4bd2z54rvy734j1q0y";
  };
  unpackPhase = ''
    7zz x $src
    ls -lah
    7zz x "NYFonts/NY Fonts.pkg"
    7zz x "Payload~" -oNY
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/opentype
    cp NY/Library/Fonts/*.otf $out/share/fonts/opentype
    runHook postInstall
  '';
}
