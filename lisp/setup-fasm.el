

(use-package fasm-mode
  :ensure (:type git :host github :repo "GabrielFrigo4/fasm-mode")
  :defer t
  :config
    )

(add-to-list 'auto-mode-alist '("\\.asm\\'" . fasm-mode))

(provide 'setup-fasm)
