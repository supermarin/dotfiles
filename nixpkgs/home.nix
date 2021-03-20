# TODO: try ditching home manager in favor of
# https://github.com/nmattia/homies
{ config, pkgs, ... }:
let
  inherit (pkgs.lib) mkIf;
  inherit (pkgs.stdenv) isLinux isDarwin;
  fonts = with pkgs; [
    fira-code
    jetbrains-mono
    go-font
  ];
in
{
  home.sessionVariables = {
    EDITOR = "vim";
    FUZZY = "fzf";
    PASSWORD_STORE_DIR="$HOME/.p";
    OTPDIR = "$HOME/.otp";
    RIPGREP_CONFIG_PATH = ./rg/config;
  };
  home.sessionPath = [
    "${config.xdg.configHome}/nixpkgs/functions"
    "$HOME/go/bin"
  ];

  # TODO: on mac, remove /usr/local/go once Nix builds for arm64
  home.packages = with pkgs; [
    age
    any-nix-shell
    bat # used in `e` for live preview of files
    coreutils # used for `shred`
    diffr # used in git stuff
    fd
    fzf
    gnupg
    jq
    magic-wormhole
    oathToolkit # used for OTP
    pass
    ripgrep
    rnix-lsp
  ]
  ++ fonts
  ++ lib.optionals isDarwin [] 
  ++ lib.optionals isLinux [
    # The following are here because of M1:
    # Nix can't compile for arm64, so I'm just using the
    # system binaries / hand compiling on the mac.
    git
    tig
    vim
  ];

  programs.alacritty = import ./alacritty.nix;
  programs.fish = import ./fish/fish.nix pkgs;
  programs.home-manager.enable = true;
  programs.git = import ./git.nix;
  programs.vscode = with pkgs; {
    enable = true;
    package = vscodium;
    extensions = [
      vscode-extensions.brettm12345.nixfmt-vscode
      vscode-extensions.jnoortheen.nix-ide
      vscode-extensions.golang.Go
      vscode-extensions.vscodevim.vim
    ];
    userSettings = {
      "editor.fontFamily" = "'Go Mono', 'Droid Sans Mono', 'monospace', monospace, 'Droid Sans Fallback'";
      "editor.fontSize" = 15;
      "editor.minimap.enabled" = false;
      "go.useLanguageServer" = true;
      "nix.enableLanguageServer" = true;
      "update.mode" = "none";
      "vim.useSystemClipboard" = true;
      "window.autoDetectColorScheme" = true;
      "window.menuBarVisibility" = "toggle";
      "window.zoomLevel" = -1;
      "workbench.activityBar.visible" = false;
      "workbench.colorTheme" = "Gruvbox Light Hard";
      "workbench.preferredDarkColorTheme" = "Gruvbox Dark Hard";
      "workbench.preferredLightColorTheme" = "Gruvbox Light Hard";
    };
  };
  home.file.".ssh/config".text = "${builtins.readFile ./ssh/config}";
  home.file.".vimrc".text = builtins.readFile ./vim/vimrc;
  home.file.".gvimrc".text = "${builtins.readFile ./vim/gvimrc}";
  home.file.".sqliterc".text = builtins.readFile ./sqliterc;
  xdg.configFile."rg/config".text = builtins.readFile ./rg/config;
  xdg.configFile."tig/config".text = builtins.readFile ./tig/config;
}
