(use-package vterm
  :ensure t
  :hook (vterm-mode . (lambda ()
                        (display-line-numbers-mode -1)
                        (setq-local global-hl-line-mode nil)))
  :config
  (setq vterm-max-scrollback 10000)

        (evil-define-key 'insert vterm-mode-map (kbd "SPC") #'vterm--self-insert)
  (add-to-list 'consult-buffer-filter "^\\*clang") 
  (add-to-list 'consult-buffer-filter "^\\*EGLOT") 
  (add-to-list 'consult-buffer-filter "^\\*Flycheck") 
  (add-to-list 'consult-buffer-filter "^\\*Epil") 
  (add-to-list 'consult-buffer-filter "^\\*Async") 
  (add-to-list 'consult-buffer-filter "^\\*elpaca") 
  (add-to-list 'consult-buffer-filter "^\\*xref") 
  )

(provide 'setup-term)
