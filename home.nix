{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  ln = file: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${file}";
in
{
  imports = [
    ./git/config.nix
    ./neovim.nix
    ./shells.nix
  ];

  home.sessionVariables = {
    PASSWORD_STORE_DIR = "$HOME/.p";
    OTPDIR = "$HOME/.otp";
    RIPGREP_CONFIG_PATH = "$HOME/.config/rg/config"; # TODO: XDG_CONFIG_HOME
    AGE_RECIPIENTS_FILE = ./age/recipients.txt;
    MANPAGER = "nvim +Man!";
  };
  home.sessionPath = [ "${dotfiles}/functions" ];
  home.packages = with pkgs; [
    age
    age-plugin-yubikey
    ansifilter # for i3status-rs ansi -> pango for yfinance
    bat # used in `e` for live preview of files
    btop
    coreutils # used for `shred`
    diffr # used in git stuff
    difftastic # testing this out
    dua # disk usage analyzer, better du -hc
    duckdb
    dysk # disk usage analyzer, better df -h
    eza # ls with stuff
    fd
    fzf
    ghostty
    git-lfs
    github-cli
    gnumake
    jq
    jujutsu
    lazyjj
    mergiraf # experimental: git conflict resolver
    nixd # nix language server
    nixfmt-rfc-style # official nix formatter used by nixd
    nushell
    oathToolkit # used for OTP
    ripgrep
    ripgrep-all
    rsync
    sqlite-interactive
    lua-language-server
    tig
    tmux-mem-cpu-load
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.tmux = {
    aggressiveResize = true;
    baseIndex = 1;
    enable = true;
    escapeTime = 0;
    extraConfig = ''
      # for neovim :checkhealth
      set -ga terminal-overrides ",xterm-256color:Tc"
      set -g default-terminal "tmux-256color"
      set -g focus-events on

      setw -g window-status-current-style fg=black,bg=pink,bold,reverse
      setw -g window-status-current-format ' #W '
      setw -g window-status-format ' #W '
      set -g status-position top
      set -g status-interval 2
      set -g status-left "#S #[fg=colour5,bg=black]#(tmux-mem-cpu-load --colors --interval 2)#[default]"
      set -g status-right "%a %b %d %H:%M"
      if-shell -b ' [ "$SSH_CLIENT" ] ' {
        set -g status-bg colour6
        set -g status-left "#S@#H #[fg=colour6,bg=black]#(tmux-mem-cpu-load --colors --interval 2)#[default]"
      }
      set -g status-left-length 60

      bind k select-pane -U
      bind j select-pane -D
      bind h select-pane -L
      bind l select-pane -R

      bind-key -n M-H select-window -t:-1
      bind-key -n M-L select-window -t:+1
      bind-key -n M-h select-pane -L
      bind-key -n M-l select-pane -R
      bind-key -n M-k select-pane -U
      bind-key -n M-j select-pane -D
      bind-key -n M-f resize-pane -Z
      bind-key -n M-n new-window
      bind-key -n M-d split-pane -h
      bind-key -n M-D split-pane -v
    '';
    historyLimit = 250000;
    keyMode = "vi";
    mouse = true;
    terminal = "xterm-256color";
  };

  home.file = {
    ".digrc".text = "+noall +answer";
    ".gnupg/gpg-agent.conf".text = "pinentry-program ${pkgs.pinentry-qt}/bin/pinentry";
    ".ssh/config".source = ln "ssh/config";
    ".sqliterc".source = ./sqliterc;
  };
  xdg.configFile = {
    "ghostty".source = ln "ghostty";
    "jj/config.toml".source = ln "jj/config.toml";
    "tig/config".source = ln "tig/config";
    "rg/config".source = ./rg/config;
  };
}
