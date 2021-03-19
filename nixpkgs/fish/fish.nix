pkgs:
{
  enable = true;
  shellInit = ''
    ${builtins.readFile ./nix.fish}

    if status --is-interactive
      abbr c clear
      abbr g git
      abbr gs git s
      abbr l la
      abbr ns nix-shell
      abbr hs home-manager switch
      abbr he home-manager edit
    end

    any-nix-shell fish --info-right | source
  '';
  promptInit = builtins.readFile ./functions/fish_prompt.fish;
  functions = with builtins; {
    wo = readFile ./functions/wo.fish;
    fish_right_prompt = readFile ./functions/fish_right_prompt.fish;
  };
}
