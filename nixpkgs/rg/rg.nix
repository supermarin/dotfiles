# TODO: this is hacky since home-manager doesn't support
# tig (or ripgrep properly either). Remove this later if
# possible.
config:
let
    rgconf = "${config.xdg.configHome}/nixpkgs/rg/config";
in
{
  xdg.configFile."rg/config".text = "${builtins.readFile rgconf}";
  home.sessionVariables = {
    RIPGREP_CONFIG_PATH = rgconf;
  };
}
