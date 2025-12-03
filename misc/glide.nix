{ pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
  name = "Glide";
  version = "0.1.54a";
  src = pkgs.fetchurl {
    url = "https://github.com/glide-browser/glide/releases/download/${version}/glide.linux-x86_64.tar.xz";
    sha256 = "sha256-Rw85b+9eaiM9szWpYZiF7FqJY7OpliOwt09/c8UWlGk=";
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
