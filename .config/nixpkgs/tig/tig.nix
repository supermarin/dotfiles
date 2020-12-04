# TODO: this is hacky since home-manager doesn't support
# tig (or ripgrep properly either). Remove this later if
# possible.
config:
let
    conf = "${config.xdg.configHome}/nixpkgs/tig/config";
in
{
  xdg.configFile."tig/config".text = "${builtins.readFile conf}";
}
