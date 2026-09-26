(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l") 
  :hook ((c-mode . lsp)
         (c++-mode . lsp)
         (python-mode . lsp))
  :commands lsp
  :config
  (setq lsp-inlay-hint-enable t
        lsp-semantic-tokens-enable t
        lsp-clients-clangd-args '("--background-index"
                                  "--clang-tidy"
                                  "--completion-style=detailed"
                                  "--header-insertion=iwyu"
                                  "--fallback-style=file"))

  (with-eval-after-load 'lsp-semantic-tokens
    (set-face-attribute 'lsp-face-semhl-constant nil :background nil)
    (set-face-attribute 'lsp-face-semhl-variable nil :background nil)
    (set-face-attribute 'lsp-face-semhl-function nil :background nil)))

(with-eval-after-load 'lsp-mode
  (evil-define-key 'normal lsp-mode-map
    (kbd "g d") 'lsp-find-definition
    (kbd "g r") 'lsp-find-references
    (kbd "K")   'lsp-describe-thing-at-point))

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-sideline-enable nil  
        lsp-ui-doc-enable t
        lsp-ui-doc-header t
        lsp-ui-doc-include-signature t))

(use-package flycheck
  :init (global-flycheck-mode))

(use-package flycheck-inline
  :ensure t
  :after flycheck
  :config
  (global-flycheck-inline-mode)
  (setq flycheck-display-errors-delay 0.1))

(use-package clang-format
  :ensure t
  :commands clang-format-region
  :hook ((c-mode c++-mode) . (lambda ()
                               (local-set-key (kbd "C-c C-f") 'clang-format-region)
                               (add-hook 'before-save-hook 'clang-format-buffer nil t))))

(provide 'setup-lsp)
