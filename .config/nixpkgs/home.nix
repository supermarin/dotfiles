{ config, pkgs, ... }:
{
  programs.home-manager.enable = true;

  home.username = "marinusalj";
  home.homeDirectory = /Users/marinusalj;
  home.packages = with pkgs; [
    bat # used in `e` for live preview of files
    diffr # used in git stuff
    fd
    fish
    fzf
    git
    gitAndTools.hub
    gitAndTools.gh
    gnupg
    go
    jq
    pass
    ripgrep
    tig
  ] ++ pkgs.stdenv.lib.optionals stdenv.isDarwin [
    # Only macOS software
    swiftformat
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    # Only Linux software
  ];

  programs.neovim = import ./vim.nix pkgs;
  programs.alacritty = import ./alacritty.nix;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";
}
#// lib.mkIf pkgs.stdenv.isLinux {}
