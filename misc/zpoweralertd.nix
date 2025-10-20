{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  name = "zpoweralertd";
  src = pkgs.fetchFromGitHub {
    owner = "mrusme";
    repo = "zpoweralertd";
    rev = "a8c191e";
    sha256 = "sha256-obX1cMP/xA0HP48yBvQeEjbKLxxwkIDWxfR6RADJhMo=";
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
