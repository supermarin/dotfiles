# TODO: remove when Inter 4 is released
{ pkgs }:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "inter";
  version = "4.00";
  src = pkgs.fetchzip {
    url = "https://github.com/supermarin/inter/releases/download/nightly-20230412/Inter-4.00-0e39527da5.zip";
    sha256 = "sha256-zthG+GMm1DkSSsZV3huercYCP8Wl2Vqs3LJbq2wiWJg=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/opentype
    cp */*.otf $out/share/fonts/opentype
    runHook postInstall
  '';

  meta = with pkgs.lib; {
    homepage = "https://rsms.me/inter/";
    description = "A typeface specially designed for user interfaces";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ demize dtzWill ];
  };
}
