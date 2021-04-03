# TODO: try ditching home manager in favor of
# https://github.com/nmattia/homies
{ config, pkgs, ... }:
let
  inherit (pkgs.lib) mkIf optionals;
  inherit (pkgs.stdenv) isLinux isDarwin;
in
{
  home.sessionVariables = {
    EDITOR = "nvim";
    FUZZY = "fzf";
    PASSWORD_STORE_DIR="$HOME/.p";
    OTPDIR = "$HOME/.otp";
    RIPGREP_CONFIG_PATH = ./rg/config;
  };

  home.sessionPath = [
    "$HOME/dotfiles/functions"
    "$HOME/go/bin"
  ];

  home.packages = with pkgs; [
    age
    bat # used in `e` for live preview of files
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
    ripgrep
    rnix-lsp
    tree-sitter
  ]
  ++ [ # fonts
    go-font
  ]
  ++ lib.optionals isDarwin [] 
  ++ lib.optionals isLinux [
    # The following are here because of M1:
    # Nix can't compile for arm64, so I'm just using the
    # system binaries / hand compiling on the mac.
    cawbird # twitter
    evolution # mail, contacts, cal
    git
    signal-desktop # for an unknown reason not avail on mac
    slack
    tdesktop
    tig
  ];

  programs.neovim = {
    package = pkgs.neovim-nightly;
    enable = true;
    vimAlias = true;
    viAlias = true;
  };
  programs.alacritty = import ./alacritty.nix;
  programs.fish = import ./fish/fish.nix pkgs;
  programs.home-manager.enable = true;
  programs.git = import ./git.nix;
  home.file.".ssh/config".text = "${builtins.readFile ./ssh/config}";
  home.file.".sqliterc".text = builtins.readFile ./sqliterc;
  xdg.configFile."nvim/init.lua".text = builtins.readFile ./vim/init.lua;
  xdg.configFile."rg/config".text = builtins.readFile ./rg/config;
  xdg.configFile."tig/config".text = builtins.readFile ./tig/config;
  xdg.configFile."sway/config".text = builtins.readFile ./linux/sway/config;
  xdg.configFile."waybar/config".text = builtins.readFile ./linux/waybar/config;
  xdg.configFile."waybar/style.css".text = builtins.readFile ./linux/waybar/style.css;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    # Neovim nightly until 0.5.0 is released (or forever?)
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];
}
