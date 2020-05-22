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
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    swiftformat
  ];

  programs.vim = {
    enable = true;
    plugins = [
      #pkgs.vimPlugins.coc-nvim
      pkgs.vimPlugins.fzfWrapper
      pkgs.vimPlugins.fzf-vim
      pkgs.vimPlugins.gruvbox
    ];
    settings = {
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      smartcase = true;
    };
    extraConfig = ''
      set smartindent
      set grepprg=rg\ --vimgrep
      set splitright
      set splitbelow

      set termguicolors
      color gruvbox

      nnoremap gh ^
      nnoremap gl $
      nnoremap <C-p> :GitFiles<cr>
    '';
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
