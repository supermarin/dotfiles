pkgs:
{
  enable = true;
  shellInit = builtins.readFile ./config.fish;
  functions = with builtins; {
    wo = readFile ./functions/wo.fish;
    fish_prompt = readFile ./functions/fish_prompt.fish;
    fish_right_prompt = readFile ./functions/fish_right_prompt.fish;
  };
}
