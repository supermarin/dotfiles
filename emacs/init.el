(load-theme 'modus-operandi-tinted)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq standard-indent 2)
(global-display-line-numbers-mode)
(custom-set-variables
  '(display-line-numbers-type 'relative))
(fido-vertical-mode 1)

(use-package affe ;; TODO: either this or rg
  :bind ("<leader>\\" . affe-grep)
        ("<leader>F" . affe-find))

(use-package consult
  :after evil
  :bind (("<leader>/" . consult-ripgrep)
	 ("<leader>b" . consult-buffer)
	 ("<leader>m" . consult-mark)))

(use-package diff-hl
  :hook
  (dired-mode . diff-hl-dired-mode)
  :config
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode))

(use-package evil
  :init
  (setq evil-want-keybinding nil) ;; for evil-collection
  (setq evil-search-module 'evil-search)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode t)
  (evil-set-leader '(normal visual) (kbd "SPC"))
  (evil-set-toggle-key "C-`")
  (evil-define-key 'normal 'global
    "gh" 'evil-beginning-of-line
    "gl" 'evil-end-of-line
    (kbd "C-r") 'undo-redo
    (kbd "<leader>f") 'fzf-git
    (kbd "<leader>g") 'majutsu
    (kbd "<leader>p") 'execute-extended-command
    (kbd "<leader>s") 'evil-update
    (kbd "<leader>q") 'evil-quit))

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode))

(use-package flymake
  :hook
  (emacs-lisp-mode . flymake-mode))

(use-package fzf
  :bind ("<leader>f" . fzf-git))

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook
    ((nix-mode . lsp-deferred)
    (python-mode . lsp-deferred)
    (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package majutsu
  :defer)

(use-package rg
  :defer)

(use-package vterm
  :bind ("<leader>t" . vterm))

(use-package which-key
  :config
  (which-key-mode))
