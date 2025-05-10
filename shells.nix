{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autocd = true;
    autosuggestion.enable = true;
    # autosuggestion.highlight = "fg=#ff00ff,bg=cyan,bold,underline";
    autosuggestion.strategy = [
      "match_prev_cmd"
      "history"
      "completion"
    ];
    defaultKeymap = "emacs";
    history.append = true;
    history.expireDuplicatesFirst = true;
    history.findNoDups = true;
    # history.ignorePatterns = [ ];
    initContent = ''
      wo() {
        local dir=$(find -L ~/code -maxdepth 2 | fzf)
        test $dir || return 1

        cd "$dir" || return
        clear
        ls -la
      }

      eval "$(${pkgs.fzf}/bin/fzf --zsh)"
      source ${./zsh-prompt.sh}
    '';
    shellAliases = {
      rm = "${pkgs.trash-cli}/bin/trash";
    };
    syntaxHighlighting.enable = true;
    syntaxHighlighting.highlighters = [ "brackets" ];
    syntaxHighlighting.styles = {
      "alias" = "fg=magenta,bold";
    };
    # zprof.enable = true;
  };
}
