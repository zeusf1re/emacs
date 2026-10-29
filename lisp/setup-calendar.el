(add-to-list 'load-path "~/.config/emacs/elisp/org-to-cal/")
(require 'org-to-cal)

;; Выбираем метод прямой синхронизации (без сервера и подписки)
(customize-set-variable 'org-to-cal-sync-method 'direct-import)
(customize-set-variable 'org-to-cal-tag "ical")

;; (Опционально) Укажите имя календаря, в который будут падать события.
;; Если оставить nil, будет использоваться календарь по умолчанию.
(customize-set-variable 'org-to-cal-target-calendar "Org")

(org-to-cal-mode 1)

;; (use-package ox-icalendar
;;   :after org
;;   :config
;;   ;; Куда сохранять объединённый .ics файл
;;   (setq org-icalendar-combined-agenda-file "~/org-agenda-export.ics")
;;   ;; Включать задачи со сроками (deadline) и запланированные (scheduled)
;;   (setq org-icalendar-include-todo t)
;;   ;; Исключать теги, которые не должны попадать в календарь (опционально)
;;   (setq org-icalendar-exclude-tags '("noexport")))

;; (add-hook 'after-save-hook
;;          (lambda ()
;;            (when (org-mode 'derived-mode-p)
;;              (org-icalendar-combine-agenda-files))))

(provide 'setup-calendar)
