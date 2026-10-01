;; ====================== SETUP-PDF.el ====================== 
(use-package pdf-tools
  :ensure t
  :mode ("\\.pdf\\'" . pdf-view-mode)   ; регистрируется сразу, не через :config
  :config
  (pdf-tools-install :no-query)         ; без "Build? y/n", без проверки pdfinfo
  (add-hook 'pdf-view-mode-hook (lambda () (display-line-numbers-mode -1))))

(use-package pdf-view-restore
  :ensure t
  :hook (pdf-view-mode . pdf-view-restore-mode))

(provide 'setup-pdf)
