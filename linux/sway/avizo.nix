with import<nixpkgs>{};
stdenv.mkDerivation {
  name = "avizo";
  src = builtins.fetchTarball https://github.com/misterdanb/avizo/archive/7b3874e5ee25c80800b3c61c8ea30612aaa6e8d1.tar.gz;
  buildInputs = [
    gtk-layer-shell
    gtk3
    vala
    glib
    gobject-introspection
    bc
  ];
  propagatedBuildInputs = [
    makeWrapper
  ];
  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];

  postInstall = with lib; ''
  wrapProgram $out/bin/lightctl --prefix PATH : ${makeBinPath [ bc ]}
  wrapProgram $out/bin/volumectl --prefix PATH : ${makeBinPath [ bc ]}
  '';
}
