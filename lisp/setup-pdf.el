;; ====================== SETUP-PDF.el ====================== 
(use-package pdf-tools
  :ensure t
  :defer t
  :config
  (when (executable-find "pdfinfo")
    (pdf-tools-install))
  (add-hook 'pdf-view-mode-hook (lambda () (display-line-numbers-mode -1)))

  (use-package pdf-view-restore
    :ensure t
    :hook (pdf-view-mode . pdf-view-restore-mode)))

(provide 'setup-pdf)
