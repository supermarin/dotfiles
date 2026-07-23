{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  name = "zpoweralertd";
  src = pkgs.fetchFromGitHub {
    owner = "mrusme";
    repo = "zpoweralertd";
    rev = "3466ae9";
    sha256 = "sha256-O+TW6q0aIdb6znJzfSVytrsrATZ0g8ZwinDItqd98hY=";
  };
  nativeBuildInputs = [
    pkgs.zig
    pkgs.pkg-config
  ];
  buildInputs = [
    pkgs.elogind
  ];
  buildPhase = "zig build --global-cache-dir .";
  installPhase = ''
    mkdir -p $out/bin
    cp -r zig-out/bin/* $out/bin/
  '';
}
