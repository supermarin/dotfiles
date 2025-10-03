{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "Glide";
  src = pkgs.fetchurl {
    url = "https://github.com/glide-browser/glide/releases/download/0.1.50a/glide.linux-x86_64.tar.xz";
    sha256 = "sha256-jOzE+727socJQAJIj2sCgUS+okx3zH79JuMzLhsEYsk=";
  };
  nativeBuildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    cd $out
    tar -xf $src

    wrapProgram $out/glide/glide \
      --prefix LD_LIBRARY_PATH : "${
        pkgs.lib.makeLibraryPath [
          pkgs.gtk3
          pkgs.libgcc
          pkgs.alsa-lib
          pkgs.libx11
        ]
      }"
    ln -s $out/glide/glide $out/bin/glide
  '';
}
