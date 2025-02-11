{ pkgs }:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "inter";
  version = "4.1";
  src = pkgs.fetchzip {
    url = "https://github.com/rsms/inter/releases/download/v4.1/Inter-4.1.zip";
    sha256 = "sha256-5vdKKvHAeZi6igrfpbOdhZlDX2/5+UvzlnCQV6DdqoQ=";
    stripRoot = false;
  };

  installPhase = ''
    set -x
    runHook preInstall
    mkdir -p $out/share/fonts/opentype
    cp extras/otf/*.otf $out/share/fonts/opentype
    runHook postInstall
  '';

  meta = with pkgs.lib; {
    homepage = "https://rsms.me/inter/";
    description = "A typeface specially designed for user interfaces";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
