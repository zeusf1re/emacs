(use-package pdf-tools
  :ensure t
  :config
    (pdf-tools-install)
  
    (add-hook 'pdf-view-mode-hook (lambda () (display-line-numbers-mode -1)))
  
    (use-package pdf-view-restore
    :ensure t
    :hook (pdf-view-mode . pdf-view-restore-mode)))

(provide 'setup-pdf)
