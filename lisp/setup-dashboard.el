(use-package dashboard
  :ensure t
  :config
  (when (fboundp 'evil-collection-remove)
    (evil-collection-remove 'dashboard))
  (advice-remove 'dashboard-insert-startupify-lists
                 'evil-collection-dashboard-setup-jump-commands)

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
 (setq dashboard-show-shortcuts nil)
(setq dashboard-footer-messages '(""))
;; --- Полностью убираем футер ---
(setq dashboard-set-footer nil)          ; отключаем отображение подвала
(setq dashboard-footer-messages nil)     ; очищаем сообщения (необязательно)
;; Удаляем функцию вставки футера из списка инициализации (гарантированно)
(setq dashboard-startupify-list (delq 'dashboard-insert-footer dashboard-startupify-list))
 )
(setq initial-buffer-choice
      (lambda ()
        (if (fboundp 'dashboard-open)
            (progn (dashboard-open) (get-buffer "*dashboard*"))
          (get-buffer-create "*scratch*"))))
(provide 'setup-dashboard)
