pkgs:
{
  enable = true;
  shellInit = ''
    if status --is-interactive
      abbr c clear
      abbr g git
      abbr gd git d
      abbr gl git pull
      abbr gp git push
      abbr gs git s
      abbr nb nix build
      abbr nd nix develop
      abbr nr nix run
      abbr nrb sudo nixos-rebuild --flake $HOME/dotfiles#$(hostname) switch
      abbr nrr nix run nixpkgs#
      abbr ns nix shell nixpkgs#
      abbr nsp nix-shell -p
      abbr nss nix search nixpkgs
    end
  '';

  interactiveShellInit = builtins.readFile ./functions/fish_prompt.fish;
  functions = with builtins; {
    wo = readFile ./functions/wo.fish;
    fish_right_prompt = readFile ./functions/fish_right_prompt.fish;
    la = ''
      eza --octal-permissions --long --all --git $argv
    '';
    pgp = ''
      pushd $PASSWORD_STORE_DIR
      git add .
      git commit -am 'update'
      git push
      popd
    '';
  };
}
