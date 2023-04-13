pkgs: {
  enable = true;
  vimAlias = true;
  viAlias = true;
  plugins = with pkgs.vimPlugins; [
    # Core editor functionality
    comment-nvim
    editorconfig-nvim
    nvim-autopairs
    vim-surround
    vim-visual-multi
    # Copilot
    copilot-lua
    copilot-cmp
    # Colorschemes
    everforest
    gruvbox-nvim
    oxocarbon-nvim
    # Telescope
    telescope-nvim
    plenary-nvim
    # Misc
    gitsigns-nvim
    vim-fugitive
    vim-repeat
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
    # Various nvim-cmp components
    cmp-nvim-lsp
    cmp-buffer
    cmp-path
    cmp-cmdline
    cmp-nvim-lsp-signature-help
  ];
}
