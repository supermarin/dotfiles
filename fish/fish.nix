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
      abbr nsp nix-shell -p 
      abbr nss nix search nixpkgs
      abbr nd nix develop
      abbr nr nix run
      abbr nb nix build
      abbr nrs sudo nixos-rebuild switch
    end
  ''
  # Unfuck nix-darwin integration with home-manager
  + pkgs.lib.optionalString pkgs.stdenv.isDarwin (builtins.readFile ./nix.fish);

  interactiveShellInit = builtins.readFile ./functions/fish_prompt.fish;
  functions = with builtins; {
    wo = readFile ./functions/wo.fish;
    fish_right_prompt = readFile ./functions/fish_right_prompt.fish;
  };
}
