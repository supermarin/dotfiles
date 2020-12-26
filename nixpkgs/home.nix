# TODO: try ditching home manager in favor of
# https://github.com/nmattia/homies
{ config, pkgs, ... }:
let
  inherit (pkgs.stdenv.lib) mkIf;
  inherit (pkgs.stdenv) isLinux isDarwin;
in
{
  home.packages = with pkgs; [
    bat # used in `e` for live preview of files
    coreutils # used for `shred`
    diffr # used in git stuff
    fd
    fzf
    gitAndTools.gh
    gitAndTools.hub
    gnupg
    go
    jq
    oathToolkit # used for OTP
    pass
    rage
    ripgrep
    tig
  ] ++ lib.optionals isDarwin [
    swiftformat
  ] ++ lib.optionals isLinux [
    firefox
    rofi
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    FUZZY = "fzf";
    PASS_STORE = ~/.password-store;
  };
  home.sessionPath = [ "${config.xdg.configHome}/nixpkgs/functions" ];

  imports = [
    (import ./rg/rg.nix config)
    (import ./tig/tig.nix config)
  ];
  programs.alacritty = import ./alacritty.nix;
  programs.fish = import ./fish/fish.nix pkgs;
  programs.home-manager.enable = true;
  programs.neovim = import ./vim.nix pkgs;
  programs.git = import ./git.nix;

  # Linux only
  xsession = mkIf isLinux (import ./linux/xsession.nix pkgs);
}
