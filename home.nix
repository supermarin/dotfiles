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
    calibre
    coreutils # used for `shred`
    diffr # used in git stuff
    fd
    fzf
    gnupg
    htop
    jq
    magic-wormhole
    oathToolkit # used for OTP
    pass
    qutebrowser
    ripgrep
    rnix-lsp
    tree-sitter
    w3m # for mail
  ]
  ++ [ # fonts
    go-font
    jetbrains-mono
  ]
  ++ lib.optionals isDarwin [] 
  ++ lib.optionals isLinux [
    cawbird # twitter
    fractal # matrix
    gcc # for neovim
    git # is here only because of arm64 git on mac
    signal-desktop # for an unknown reason not avail on mac
    slack # same arm64
    sqlite # needed by neovim sqlite. not by default in the OS
    tdesktop # telegram
    tig # same arm64
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
  xdg.configFile."nvim/init.vim".text = ''
    " The line below is generated from home-manager
    let g:sqlite_clib_path = "${pkgs.sqlite.out}/lib/libsqlite3.so"
    ''
    + builtins.readFile ./vim/init.vim;
  xdg.configFile."nvim/lua/luainit.lua".text = builtins.readFile ./vim/lua/luainit.lua;
  xdg.configFile."rg/config".text = builtins.readFile ./rg/config;
  xdg.configFile."foot/foot.ini".text = ''
  [cursor]
  color=000000 ffffff
  [colors]
  alpha = 1.0
  foreground = ffffff
  background = 000000
  regular0=666666
  regular1=cc6666
  regular2=66cc99
  regular3=cc9966
  regular4=6699cc
  regular5=cc6699
  regular6=66cccc
  regular7=cccccc
  bright0=999999
  bright1=ff9999
  bright2=99ffcc
  bright3=ffcc99
  bright4=99ccff
  bright5=ff99cc
  bright6=99ffff
  bright7=ffffff

  [mouse-bindings]
  primary-paste = none
  '';
  xdg.configFile."sway/config".text = builtins.readFile ./linux/sway/config;
  xdg.configFile."tig/config".text = builtins.readFile ./tig/config;

  nixpkgs = {
    config.allowUnfree = true;
    # overlays = [
    # ];
  };
  xdg.mimeApps = { 
    enable = true;
    # associations.added = { 
    #   "application/pdf" = ["org.gnome.Evince.desktop"];
    # };
    defaultApplications = { 
      "application/pdf" = ["qutebrowser"];
    };
  }; 
}
