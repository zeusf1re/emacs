(use-package dashboard
  :ensure t
  :config
  (when (fboundp 'evil-collection-remove)
    (evil-collection-remove 'dashboard))

 ;; --- Баннер ---
 (setq dashboard-startup-banner "~/Downloads/-2.jpg") ; без пробелов!
 (setq dashboard-center-content t)
 (setq dashboard-banner-logo-title nil)

  ;; --- Убираем время загрузки ---
  (setq dashboard-init-info "")

  ;; --- Разделы ---
  (setq dashboard-items '((agenda . 5)))

  (setq dashboard-agenda-sort-strategy '((time-up)))

  ;; --- Скрыть подсказки клавиш ---
  (setq dashboard-set-footer nil)
  (setq dashboard-show-shortcuts nil)

  (setq dashboard-footer-messages (""))
  )
(setq initial-buffer-choice (lambda () (dashboard-open) (get-buffer "*dashboard*")))
;;(use-package dashboard
;;  :ensure t
;;  :config
;;  (setq dashboard-items '((agenda . 5)))
;;  (dashboard-setup-startup-hook))
(provide 'setup-dashboard)
