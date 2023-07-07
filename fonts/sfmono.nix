{ pkgs }:

pkgs.stdenvNoCC.mkDerivation rec {
  buildInputs = [ pkgs._7zz ];
  name = "SF Mono";
  src = builtins.fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg";
    sha256 = "sha256:0fdcras7y7cvym6ahhgn7ih3yfkkhr9s6h5b6wcaw5svrmi6vbxb";
  };
  unpackPhase = ''
    7zz x $src
    7zz x "SFMonoFonts/SF Mono Fonts.pkg"
    7zz x "Payload~" -oSFMono
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/opentype
    cp SFMono/Library/Fonts/*.otf $out/share/fonts/opentype
    runHook postInstall
  '';
}
