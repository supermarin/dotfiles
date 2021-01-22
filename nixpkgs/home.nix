# TODO: try ditching home manager in favor of
# https://github.com/nmattia/homies
{ config, pkgs, ... }:
let
  inherit (pkgs.stdenv.lib) mkIf;
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
    "$HOME/sdk/gotip/bin/darwin_arm64"
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
    jq
    oathToolkit # used for OTP
    pass
    ripgrep
  ] ++ lib.optionals isDarwin [
  ] ++ lib.optionals isLinux [
    go
    gopls
    rofi
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
  home.file.".vimrc".text = "${builtins.readFile ./vim/vimrc}";

  # Linux only
  xsession = mkIf isLinux (import ./linux/xsession.nix pkgs);
}
