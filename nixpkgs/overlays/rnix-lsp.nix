self: super:
#let
#    src = self.Tarball {
#      url = https://github.com/nix-community/rnix-lsp/archive/master.tar.gz;
#      #hash = "sha256-1g5gyg6zfl7i54dycxwgabj34cfdd87siszkk15f5aqvay86v2wm";
#    };
#in
{
  rnix-lsp-nightly = super.rnix-lsp.overrideAttrs(drv: {
#    src = src;
    version = "a9cbcb4f2719cc11180e9d6ce2b6518d81552b9d";
#    cargoDeps = drv.cargoDeps.overrideAttrs (_: {
#      name = "rnix-lsp-nightly";
#      # You need to pass "src" here again, 
#      # otherwise the old "src" will be used.
#      inherit src;
#      outputHash = "sha256-1g5gyg6zfl7i54dycxwgabj34cfdd87siszkk15f5aqvay86v2wm";
#    });
  });
}
