{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # WAT this seems required as of 20.09. Maybe a bug?
  home.username = "marinusalj";
  home.homeDirectory = /Users/marinusalj;
  home.packages = with pkgs; [
    bat # used in `e` for live preview of files
    cacert # req by nix
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
    nix
    pass
    ripgrep
    tig
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    swiftformat
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    alacritty
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
