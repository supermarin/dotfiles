{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
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
    nix
    notmuch
    pass
    ripgrep
    tig
    neovim
    vim
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    swiftformat
  ];

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 4800;
    #enableSshSupport = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font.size = 16;
    };
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
