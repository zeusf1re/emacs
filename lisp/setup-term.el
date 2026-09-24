(use-package vterm
  :ensure t
  :hook (vterm-mode . (lambda ()
                        (display-line-numbers-mode -1)
                        (setq-local global-hl-line-mode nil)))
  :config
  (setq vterm-max-scrollback 10000)

  (evil-define-key 'insert vterm-mode-map (kbd "SPC") #'vterm--self-insert))

(provide 'setup-term)
