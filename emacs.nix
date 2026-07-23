{
  services.emacs.enable = true;
  programs.emacs = {
    enable = true;
    extraPackages = e: [
      e.affe # TODO: remove either this or fzf
      e.consult
      e.ement
      e.evil
      e.evil-collection
      e.evil-commentary
      e.evil-surround
      e.diff-hl
      e.fzf
      e.lsp-mode
      e.majutsu
      e.nix-mode
      e.python-mode
      e.rg
      e.vterm
    ];
    extraConfig = ''
      (setq user-init-file "~/.config/emacs/init.el")
      (load-file user-init-file)
      (setq custom-file "~/.config/emacs/custom.el")
      (load custom-file)
    '';
  };
}
