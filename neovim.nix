pkgs: {
  enable = true;
  vimAlias = true;
  viAlias = true;
  plugins = with pkgs.vimPlugins; [
    # Core editor functionality
    editorconfig-nvim
    nvim-autopairs
    vim-visual-multi
    # Colorschemes
    gruvbox-nvim
    # Telescope
    telescope-nvim
    plenary-nvim
    # Misc
    gitsigns-nvim
    vim-commentary
    vim-fugitive
    vim-repeat
    vim-surround
    vim-test
    which-key-nvim
    # Snippets
    luasnip
    cmp_luasnip
    friendly-snippets
    # Tree-sitter
    nvim-treesitter.withAllGrammars
    nvim-ts-rainbow
    # DAP
    nvim-dap
    nvim-dap-ui
    nvim-dap-virtual-text
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
