{
  pkgs,
  config,
  ...
}:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      # Core editor functionality
      blink-cmp
      editorconfig-nvim
      nvim-autopairs
      nvim-lspconfig # TODO: remove when lspcofig is merged into neovim
      vim-repeat
      vim-surround
      vim-visual-multi
      # DAP
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      nvim-dap-python
      # AI
      codecompanion-nvim
      # Telescope
      telescope-nvim
      plenary-nvim
      # Git
      gitsigns-nvim
      # Misc
      vim-test
      which-key-nvim
      # Tree-sitter
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      # Theming
      mini-hues
      mini-icons
    ];
  };
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
}
