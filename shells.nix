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
    history.saveNoDups = true;
    history.ignoreDups = true;
    history.ignorePatterns = [
      "vim *"
      "vi *"
      "nvim *"
    ];
    initContent = ''
      # if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then
      #   tmux attach-session -t "L F G!!!" || tmux new-session -s "L F G!!!"
      # fi

      eval "$(${pkgs.fzf}/bin/fzf --zsh)"
      source ${./zsh-prompt.sh}
    '';
    shellAliases = {
      rm = "${pkgs.trash-cli}/bin/trash";
      wo = ". wof"; # needed so it runs in the same process and cd's
      nd = "nix develop";
    };
    syntaxHighlighting.enable = true;
    syntaxHighlighting.highlighters = [ "brackets" ];
    # zprof.enable = true;
  };
}
