# TODO: try ditching home manager in favor of
# https://github.com/nmattia/homies
{ config, pkgs, ... }:
let
  inherit (pkgs.stdenv.lib) mkIf;
  inherit (pkgs.stdenv) isLinux isDarwin;
in
{
  home.sessionVariables = {
    EDITOR = "v";
    FUZZY = "fzf";
    PASS_STORE = "$HOME/.password-store";
    OTPDIR = "$HOME/.otp";
  };
  home.sessionPath = [
    "${config.xdg.configHome}/nixpkgs/functions"
    "$HOME/sdk/gotip/bin/darwin_arm64"
    "$HOME/go/bin"
  ];

  home.packages = with pkgs; [
    bat # used in `e` for live preview of files
    coreutils # used for `shred`
    diffr # used in git stuff
    fd
    fzf
    gitAndTools.gh
    gitAndTools.hub
    gnupg
    jq
    oathToolkit # used for OTP
    pass
    rage
    ripgrep
  ] ++ lib.optionals isDarwin [
  ] ++ lib.optionals isLinux [
    firefox
    rofi
    tig
  ];


  imports = [
    (import ./rg/rg.nix config)
    (import ./tig/tig.nix config)
  ];

  programs.alacritty = import ./alacritty.nix;
  programs.fish = import ./fish/fish.nix pkgs;
  programs.home-manager.enable = true;
  programs.vim = import ./vim.nix pkgs;
  programs.git = import ./git.nix;

  # Linux only
  xsession = mkIf isLinux (import ./linux/xsession.nix pkgs);
}
