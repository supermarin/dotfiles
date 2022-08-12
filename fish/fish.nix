pkgs:
{
  enable = true;
  shellInit = ''
    if status --is-interactive
      abbr c clear
      abbr g git
      abbr gs git s
      abbr gd git d
      abbr ns nix shell nixpkgs#
      abbr nsp nix-shell -p
      abbr nss nix search nixpkgs
      abbr nd nix develop
      abbr nr nix run
      abbr nrr nix run nixpkgs#
      abbr nb nix build
      abbr nrs sudo nixos-rebuild switch
    end

  interactiveShellInit = builtins.readFile ./functions/fish_prompt.fish;
  functions = with builtins; {
    wo = readFile ./functions/wo.fish;
    fish_right_prompt = readFile ./functions/fish_right_prompt.fish;
  };
}
