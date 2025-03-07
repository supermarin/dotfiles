{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      # Core editor functionality
      comment-nvim
      editorconfig-nvim
      nvim-autopairs
      vim-repeat
      vim-surround
      vim-visual-multi
      # code intel
      codecompanion-nvim
      # Telescope
      telescope-nvim
      plenary-nvim
      # Git
      gitsigns-nvim
      # Misc
      vim-test
      which-key-nvim
      # Snippets
      luasnip
      cmp_luasnip
      # Tree-sitter
      nvim-treesitter.withAllGrammars
      # DAP
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      nvim-dap-python
      # Completion
      nvim-cmp
      nvim-lspconfig
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lsp-signature-help
      lspkind-nvim
    ];
  };
}
