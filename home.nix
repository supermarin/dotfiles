{ config, pkgs, ... }:
let
  inherit (pkgs.lib) mkIf optionals;
  inherit (pkgs.stdenv) isLinux isDarwin;
in
{
  home.sessionVariables = {
    EDITOR = "nvim";
    FUZZY = "fzf";
    MAILDIR = "$HOME/.mail";
    PASSWORD_STORE_DIR="$HOME/.p";
    OTPDIR = "$HOME/.otp";
    RIPGREP_CONFIG_PATH = ./rg/config;
  };

  home.sessionPath = [
    "$HOME/dotfiles/functions"
    "$HOME/go/bin"
  ];

  imports = [
    ./mail.nix
  ];

  home.packages = with pkgs; [
    age
    bat # used in `e` for live preview of files
    coreutils # used for `shred`
    diffr # used in git stuff
    fd
    fzf
    git
    gnupg
    helix
    htop
    jq
    wormhole-william
    oathToolkit # used for OTP
    pass
    ripgrep
    rnix-lsp
    sqlite # needed by neovim sqlite. not by default in the OS
    tig
    tree-sitter
  ]
  ++ [ # fonts
    go-font
    jetbrains-mono
  ]
  ++ lib.optionals isDarwin [] 
  ++ lib.optionals isLinux [
    calibre # books
    cawbird # twitter
    fractal # matrix
    gcc # for neovim
    signal-desktop # for an unknown reason not avail on mac
    slack
    tdesktop # telegram
    vlc
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
  };
  
  home.file.".sqliterc".text = builtins.readFile ./sqliterc;
  home.file.".ssh/config".text = "${builtins.readFile ./ssh/config}";
  programs.fish = import ./fish/fish.nix pkgs;
  programs.git = import ./git.nix;
  xdg.configFile."i3status-rust/config.toml".text = builtins.readFile ./linux/sway/i3status-rs/config.toml;
  xdg.configFile."nvim/colors/supermarin.vim".text = builtins.readFile ./vim/colors/supermarin.vim;
  xdg.configFile."nvim/init.vim".text = ''
    " The line below is generated from home-manager
    let g:sqlite_clib_path = "${pkgs.sqlite.out}/lib/libsqlite3.so"
    ''
    + builtins.readFile ./vim/init.vim;
  xdg.configFile."nvim/lua/luainit.lua".text = builtins.readFile ./vim/lua/luainit.lua;
  xdg.configFile."rg/config".text = builtins.readFile ./rg/config;
  xdg.configFile."sway/config".text = builtins.readFile ./linux/sway/config;
  xdg.configFile."tig/config".text = builtins.readFile ./tig/config;

  xdg.mimeApps = { 
    enable = isLinux;
    associations.added = { 
      "application/pdf" = ["mupdf.desktop"];
      "text/html" = ["mupdf.desktop"];
    };
    defaultApplications = { 
      "application/pdf" = ["mupdf.desktop"];
      "text/html" = ["mupdf.desktop"];
    };
  }; 

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      current = "uint32 0";
      sources = [ "('xkb', 'us')" ];
      xkb-options = [ "ctrl:nocaps" "altwin:swap_lalt_lwin" ];
    };
    "org/gnome/desktop/interface" = {
      clock-show-seconds = false;
      color-scheme = "prefer-dark";
      cursor-size = 32;
      document-font-name = "Inter 11";
      enable-hot-corners = false;
      font-name = "Inter 9";
      monospace-font-name = "JetBrains Mono 10";
      show-battery-percentage = true;
      text-scaling-factor = 1.25;
      locate-pointer = true;
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-temperature = "uint32 3202";
    };
    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = ["<Shift><Super>h"];
      toggle-tiled-right = ["<Shift><Super>l"];
    };
    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>q"];
      cycle-group = ["<Super>l"];
      cycle-group-backward = ["<Super>h"];
      minimize = [];
      move-to-workspace-1 = ["<Shift><Super>exclam"];
      move-to-workspace-2 = ["<Shift><Super>at"];
      move-to-workspace-3 = ["<Shift><Super>numbersign"];
      move-to-workspace-4 = ["<Shift><Super>dollar"];
      move-to-workspace-5 = ["<Shift><Super>percent"];
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
      switch-to-workspace-5 = ["<Super>5"];
      switch-to-workspace-left = ["<Super>k"];
      switch-to-workspace-right = ["<Super>j"];
      switch-windows = ["<Shift><Super>asciitilde"];
      switch-windows-backward = ["<Super>asciitilde"];
      toggle-fullscreen = ["<Super>f"];
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      screensaver = ["<Control><Super>q"];
      www = ["<Super>b"];
      email = ["<Super>e"];
      custom-keybindings = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "kgx";
      name = "Launch terminal";
    };
  };
}
