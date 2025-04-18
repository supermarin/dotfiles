{ pkgs }:

pkgs.stdenvNoCC.mkDerivation {
  buildInputs = [ pkgs._7zz ];
  name = "New York";
  src = builtins.fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/NY.dmg";
    sha256 = "sha256:1c5h9szggmwspba8gj06jlx30x83m9q6k9cdyg8dkivnij9am369";
  };
  unpackPhase = ''
    7zz x $src
    7zz x "NYFonts/NY Fonts.pkg"
    7zz x "NYFonts.pkg/Payload" -oNY
    7zz x "NY/Payload~" -oNY
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/opentype
    mkdir -p $out/share/fonts/truetype
    cp NY/Library/Fonts/*.otf $out/share/fonts/opentype
    cp NY/Library/Fonts/*.ttf $out/share/fonts/truetype
    runHook postInstall
  '';
}
