{ config, pkgs, ... }:
let
  inherit (pkgs.lib) mkIf optionals;
  inherit (pkgs.stdenv) isLinux isDarwin;
in
{
  home.stateVersion = "22.05";
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
    nodejs # for github copilot only
    oathToolkit # used for OTP
    obsidian
    pass
    ripgrep
    rnix-lsp
    tig
    tree-sitter
    wormhole-william
  ]
  ++ [ # text editing (non-system) fonts
    go-font
    jetbrains-mono
  ]
  ++ lib.optionals isDarwin [] 
  ++ lib.optionals isLinux [
    calibre # books. Unsupported on aarch64-darwin as of Aug 10 2022
    cawbird # twitter
    fractal # matrix. Unsupported on aarch64-darwin as of Aug 10 2022 (libhandy)
    gcc # for neovim
    slack
    signal-desktop # Unsupported on aarch64-darwin as of Aug 10 2022
    tdesktop # telegram
    thunderbird
    vlc # Unsupported on aarch64-darwin as of Aug 10 2022
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
  };

  programs.kitty = {
    enable = true;
    theme = "Ir Black";
    font = {
      name = "JetBrains Mono";
      size = 14;
    };
  };
  
  home.file.".sqliterc".text = builtins.readFile ./sqliterc;
  home.file.".ssh/config".text = builtins.readFile ./ssh/config;
  programs.fish = import ./fish/fish.nix pkgs;
  programs.git = import ./git.nix;
  xdg.configFile."i3status-rust/config.toml".text = builtins.readFile ./linux/sway/i3status-rs/config.toml;
  xdg.configFile."nvim/colors/supermarin.vim".text = builtins.readFile ./vim/colors/supermarin.vim;
  xdg.configFile."nvim/init.vim".text = builtins.readFile ./vim/init.vim;
  xdg.configFile."nvim/lua/luainit.lua".text = builtins.readFile ./vim/lua/luainit.lua;
  xdg.configFile."rg/config".text = builtins.readFile ./rg/config;
  xdg.configFile."sway/config".text = builtins.readFile ./linux/sway/config;
  xdg.configFile."tig/config".text = builtins.readFile ./tig/config;
}
