{
  config,
  pkgs,
  ...
}:
let
  cursor-fhs = pkgs.buildFHSEnv {
    name = "cursor";
    targetPkgs = pkgs: with pkgs; [ code-cursor ];
    runScript = "cursor";
  };
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  ln = file: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${file}";
in
{
  imports = [
    ./linux/gnome/dconf.nix
    ./neovim.nix
    ./git/config.nix
    ./shells.nix
  ];

  home.sessionVariables = {
    PASSWORD_STORE_DIR = "$HOME/.p";
    OTPDIR = "$HOME/.otp";
    RIPGREP_CONFIG_PATH = "$HOME/.config/rg/config"; # TODO: XDG_CONFIG_HOME
    AGE_RECIPIENTS_FILE = ./age/recipients.txt;
  };

  home.sessionPath = [ "${dotfiles}/functions" ];

  home.packages = with pkgs; [
    # calibre # books. Unsupported on aarch64-darwin as of Aug 10 2022. Build faling on python3.12-pyqt6-6.7.0.dev2404081550.drv
    obsidian
    age
    age-plugin-yubikey
    ansifilter # for i3status-rs ansi -> pango for yfinance
    bat # used in `e` for live preview of files
    btop
    coreutils # used for `shred`
    cursor-fhs
    diffr # used in git stuff
    difftastic # testing this out
    discord
    distrobox
    distrobox-tui
    duckdb
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
    kitty
    keepassxc
    mergiraf # experimental: git conflict resolver
    neovide # neovim gui I never use
    neovim-gtk # neovim gui I never use 2
    nixd # nix language server
    nixfmt-rfc-style # official nix formatter used by nixd
    nodejs-slim_20 # for copilot
    nushell
    oathToolkit # used for OTP
    quickemu
    ripgrep
    ripgrep-all
    rsync
    signal-desktop # Unsupported on aarch64-darwin as of Aug 10 2022
    sqlite-interactive
    spotify
    lua-language-server
    tig
    tmux-mem-cpu-load
    tradingview
    ungoogled-chromium
    vdirsyncer # sync contacts & calendars
    vlc # Unsupported on aarch64-darwin as of Aug 10 2022
    vscodium-fhs
    whatsapp-for-linux
    zed-editor
    zig # why was this? for the compiler IIRC? TODO: delete if unused
    zoom-us
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

  programs.librewolf = {
    enable = true;
    settings = {
      "browser.startup.homepage" = "https://lobste.rs";
      "media.peerconnection.enabled" = false;
      "network.cookie.lifetimePolicy" = 0;
      "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "privacy.clearOnShutdown.downloads" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.resistFingerprinting" = false;
      "webgl.disabled" = false;
      # this was because some sites (document which) were not recognizing librewolf
      # it looks like it's ok now
      # "general.useragent.override" =
      #   "Mozilla/5.0 (X11; Linux x86_64; rv:126.0) Gecko/20100101 Firefox/126.0.1";
    };
  };

  services.ollama.enable = true;

  home.file = {
    ".digrc".text = "+noall +answer";
    ".gnupg/gpg-agent.conf".text = "pinentry-program ${pkgs.pinentry-qt}/bin/pinentry";
    ".ssh/config".source = ln "ssh/config";
    ".sqliterc".source = ./sqliterc;
  };
  xdg.configFile = {
    "cosmic".source = ln "cosmic";
    "jj/config.toml".source = ln "jj/config.toml";
    "kanshi/config".source = ln "kanshi/config";
    "river/init".source = ln "river/init";
    "tig/config".source = ln "tig/config";
    "rg/config".source = ./rg/config;
    "zed/keymap.json".source = ln "zed/keymap.json";
    "zed/settings.json".source = ln "zed/settings.json";
    "i3status-rust/config.toml".source = ./linux/i3status-rs/config.toml;
    "sway/config".source = ln "linux/sway/config";
  };
}
