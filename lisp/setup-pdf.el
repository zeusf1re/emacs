(use-package pdf-tools
  :ensure t
  :config
  ;; Инициализируем (эта команда также сделает pdf-view-mode режимом по умолчанию для PDF)
  (pdf-tools-install)
  
  ;; (Опционально) Убираем лишние полосы прокрутки и тулбары в режиме чтения
  (add-hook 'pdf-view-mode-hook (lambda () (display-line-numbers-mode -1)))
  
  ;; (Опционально) Позволяет открывать PDF на той же странице, где закрыл
  (use-package pdf-view-restore
    :ensure t
    :hook (pdf-view-mode . pdf-view-restore-mode)))

(provide 'setup-pdf)
