pkgs:
{
  enable = true;
  shellInit = ''
    if status --is-interactive
      abbr c clear
      abbr g git
      abbr gs git s
      abbr gd git d
      abbr ns nix-shell
    end
  ''
  # Unfuck nix-darwin integration with home-manager
  + pkgs.lib.optionalString pkgs.stdenv.isDarwin (builtins.readFile ./nix.fish);

  promptInit = builtins.readFile ./functions/fish_prompt.fish;
  functions = with builtins; {
    wo = readFile ./functions/wo.fish;
    fish_right_prompt = readFile ./functions/fish_right_prompt.fish;
  };
}
