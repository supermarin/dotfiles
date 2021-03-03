# TODO: try ditching home manager in favor of
# https://github.com/nmattia/homies
{ config, pkgs, ... }:
let
  inherit (pkgs.lib) mkIf;
  inherit (pkgs.stdenv) isLinux isDarwin;
in
{
  home.sessionVariables = {
    EDITOR = "vim";
    FUZZY = "fzf";
    PASSWORD_STORE_DIR="$HOME/.p";
    OTPDIR = "$HOME/.otp";
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
    oathToolkit # used for OTP
    pass
    ripgrep
  ] ++ lib.optionals isDarwin [
  ] ++ lib.optionals isLinux [
    rofi
    rofi-pass
    tig
    xsel
  ];

  imports = [
    (import ./rg/rg.nix config)
    (import ./tig/tig.nix config)
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
      "go.useLanguageServer" = true;
      "editor.minimap.enabled" = false;
      "nix.enableLanguageServer" = true;
      "update.mode" = "none";
      "workbench.activityBar.visible" = false;
      "workbench.colorTheme" = "Gruvbox Dark Medium";
      "telemetry.enableTelemetry" = false;
    };
  };
  home.file.".ssh/config".text = "${builtins.readFile ./ssh/config}";
  home.file.".vimrc".text = "${builtins.readFile ./vim/vimrc}";
  home.file.".sqliterc".text = "${builtins.readFile ./sqliterc}";

  # Linux only
  xsession = mkIf isLinux (import ./linux/xsession.nix pkgs);
}
