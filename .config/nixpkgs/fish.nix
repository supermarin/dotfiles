pkgs:
{
  enable = true;
  shellInit = builtins.readFile ../fish/config.fish;
}
