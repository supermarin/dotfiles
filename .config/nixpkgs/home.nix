{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    bat
    cacert
    diffr
    fd
    fish
    fzf
    git
    gitAndTools.hub
    gnupg
    go
    jq
    neovim # TODO: remove completely?
    nix
    notmuch
    pass
    ripgrep
    tig
    vim
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    swiftformat
  ];

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 4800;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";
}
