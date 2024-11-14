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
    whatsapp = ''${pkgs.ungoogled-chromium}/bin/chromium --ozone-platform-hint=auto --force-dark-mode --enable-features=WebUIDarkMode --app="https://web.whatsapp.com"'';
    remotevsc = ''${pkgs.ungoogled-chromium}/bin/chromium --ozone-platform-hint=auto --force-dark-mode --enable-features=WebUIDarkMode --app="https://mufasa.dingo-marlin.ts.net/?folder=%2Fhome%2Fmarin%2Fcode%2Fsquale-capital&tkn=04392cca-4c44-4753-8c0a-26b70ba3d161"'';


    la = ''
      eza --octal-permissions --long --all --git $argv
    '';
    readlinks = ''
      set link $argv[1]
      if ! test -L $link
        echo "error: not a link: $argv[1]"
        return
      end
      while test -L $link
          set link (readlink $link)
      end

      echo $link
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
