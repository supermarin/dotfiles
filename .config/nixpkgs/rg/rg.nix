config:
let
    rgconf = "${config.xdg.configHome}/nixpkgs/rg/config";
in
{
  xdg.configFile.".rgrc".text = "${builtins.readFile rgconf}";
  home.sessionVariables = {
    RIPGREP_CONFIG_PATH = rgconf;
  };
}
