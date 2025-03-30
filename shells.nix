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
    initExtra = ''
      wo() {
        local dir=$(find -L ~/code -maxdepth 2 | fzf)
        test $dir || return 1

        if [[ -n "$TMUX" ]]; then
          # TODO: open new tab in tmux?
          tmux rename-window "$(basename "$dir")"
        fi

        cd "$dir" || return
        clear
        ls -la
      }

      eval "$(${pkgs.fzf}/bin/fzf --zsh)"
      eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh)"
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
