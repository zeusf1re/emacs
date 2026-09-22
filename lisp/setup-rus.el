

(use-package reverse-im
  :ensure t
  :after evil
  :custom
      (reverse-im-input-methods '("russian-computer"))
  :config
    (reverse-im-mode t))

(provide 'setup-rus)
