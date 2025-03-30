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

  home.sessionPath = [ "$HOME/dotfiles/functions" ];

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
    neovide # neovim gui
    nixd # nix language server
    nixfmt-rfc-style # official nix formatter used by nixd
    nodejs-slim_20 # for copilot
    nushell
    oathToolkit # used for OTP
    ripgrep
    ripgrep-all
    rsync
    signal-desktop # Unsupported on aarch64-darwin as of Aug 10 2022
    sqlite-interactive
    spotify
    sumneko-lua-language-server
    tig
    tmux-mem-cpu-load
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
      "browser.startup.homepage" = "https://kagi.com";
      "network.cookie.lifetimePolicy" = 0;
      "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "privacy.clearOnShutdown.downloads" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.resistFingerprinting" = false;
      "webgl.disabled" = false;
      "general.useragent.override" =
        "Mozilla/5.0 (X11; Linux x86_64; rv:126.0) Gecko/20100101 Firefox/126.0.1";
    };
  };

  services.ollama.enable = true;

  home.file.".digrc".text = "+noall +answer";
  home.file.".gnupg/gpg-agent.conf".text = "pinentry-program ${pkgs.pinentry-qt}/bin/pinentry";
  home.file.".sqliterc".source = ./sqliterc;
  home.file.".ssh/config".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ssh/config";
  xdg.configFile."i3status-rust/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/linux/sway/i3status-rs/config.toml";
  xdg.configFile."jj/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/jj/config.toml";
  xdg.configFile."kanshi/config".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/kanshi/config";
  xdg.configFile."nvim/init.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/vim/init.lua";
  xdg.configFile."rg/config".source = ./rg/config;
  xdg.configFile."river/init".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/river/init";
  xdg.configFile."sway/config".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/linux/sway/config";
  xdg.configFile."tig/config".source = ./tig/config;
  xdg.configFile."zed/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zed/settings.json";
  xdg.configFile."zed/keymap.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zed/keymap.json";

  # Directories
  xdg.configFile."cosmic".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/cosmic";
}
