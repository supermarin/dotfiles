{
  config,
  inputs,
  pkgs,
  ...
}:
let
  # zed-fhs = pkgs.buildFHSEnv {
  #   name = "zed";
  #   targetPkgs = pkgs: [
  #     inputs.zed.packages.${pkgs.system}.zed-editor
  #   ];
  #   runScript = "zed";
  # };
  cursor-fhs = pkgs.buildFHSEnv {
    name = "cursor";
    targetPkgs = pkgs: with pkgs; [ code-cursor ];
    runScript = "cursor";
  };
in
{
  imports = [ ./linux/gnome/dconf.nix ];

  home.sessionVariables = {
    EDITOR = "nvim";
    FUZZY = "fzf";
    MAILDIR = "$HOME/.mail";
    PASSWORD_STORE_DIR = "$HOME/.p";
    OTPDIR = "$HOME/.otp";
    RIPGREP_CONFIG_PATH = "$HOME/.config/rg/config"; # TODO: XDG_CONFIG_HOME
    NIXOS_OZONE_WL = "1"; # https://discourse.nixos.org/t/partly-overriding-a-desktop-entry/20743/2
    AGE_RECIPIENTS_FILE = ./age/recipients.txt;
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/yubikey-agent/yubikey-agent.sock";
  };

  home.sessionPath = [ "$HOME/dotfiles/functions" ];

  home.packages = with pkgs; [
    # calibre # books. Unsupported on aarch64-darwin as of Aug 10 2022. Build faling on python3.12-pyqt6-6.7.0.dev2404081550.drv
    obsidian
    age
    age-plugin-yubikey
    bat # used in `e` for live preview of files
    btop
    coreutils # used for `shred`
    cursor-fhs
    diffr # used in git stuff
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
    kitty
    keepassxc
    neovide # neovim gui
    nixd # nix language server
    nixfmt-rfc-style # official nix formatter used by nixd
    nodejs-slim_20 # for copilot
    nushell
    oathToolkit # used for OTP
    rio # terminal, seems to work ok with Berkeley Mono
    ripgrep
    ripgrep-all
    signal-desktop # Unsupported on aarch64-darwin as of Aug 10 2022
    sqlite-interactive
    spotify
    sumneko-lua-language-server
    tig
    ungoogled-chromium
    vdirsyncer # sync contacts & calendars
    vlc # Unsupported on aarch64-darwin as of Aug 10 2022
    vscodium-fhs
    whatsapp-for-linux
    # zed-fhs # deps are broken
    zed-editor
    zig # why was this? for the compiler IIRC? TODO: delete if unused
    zulip
    zulip-term
    zoom-us
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.tmux = {
    aggressiveResize = true;
    baseIndex = 1;
    enable = true;
    extraConfig = ''
      set -g status-position top
    '';
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    terminal = "xterm-256color";
    # terminal = "xterm-ghostty";
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

  programs.fish = import ./fish/fish.nix pkgs;
  programs.git = import ./git.nix pkgs;
  programs.neovim = import ./neovim.nix pkgs;
  home.file.".digrc".text = "+noall +answer";
  home.file.".gnupg/gpg-agent.conf".text = "pinentry-program ${pkgs.pinentry-qt}/bin/pinentry";
  home.file.".sqliterc".source = ./sqliterc;
  home.file.".ssh/config".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ssh/config";
  xdg.configFile."i3status-rust/config.toml".source = ./linux/sway/i3status-rs/config.toml;
  xdg.configFile."jj/config.toml".source = ./jj/config.toml;
  xdg.configFile."kanshi/config".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/kanshi/config";
  xdg.configFile."khal/config".source = ./khal/config;
  xdg.configFile."nvim/init.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/vim/init.lua";
  xdg.configFile."rg/config".source = ./rg/config;
  xdg.configFile."river/init".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/river/init";
  xdg.configFile."sway/config".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/linux/sway/config";
  xdg.configFile."tig/config".source = ./tig/config;
  xdg.configFile."vdirsyncer/config".source = ./secrets/vdirsyncer.conf;
  xdg.configFile."zed/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zed/settings.json";
  xdg.configFile."zed/keymap.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zed/keymap.json";

  # Directories
  xdg.configFile."cosmic".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/cosmic";
}
