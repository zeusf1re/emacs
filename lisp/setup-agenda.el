(setq org-agenda-files (directory-files-recursively "~/org" "\\.org$"))

;; Вид: 7 дней начиная с сегодняшнего дня (а не календарная неделя)
(setq org-agenda-start-on-weekday nil)  ; не привязываться к понедельнику
(setq org-agenda-start-day "+0d")       ; начинать с сегодня
(setq org-agenda-span 7)                ; 7 дней

(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys)

  ;; Привязываем команды к motion state (основной режим в agenda)
  (evil-define-key 'motion org-agenda-mode-map
    (kbd "t") 'org-agenda-todo          ; переключить TODO/DONE
    (kbd "I") 'org-agenda-clock-in      ; clock in
    (kbd "O") 'org-agenda-clock-out     ; clock out
    (kbd "s") 'org-agenda-schedule      ; перенести задачу
    (kbd "d") 'org-agenda-deadline      ; установить дедлайн
    (kbd "c") 'org-capture              ; новая задача с датой
    (kbd "q") 'org-agenda-quit          ; выход
    (kbd "r") 'org-agenda-redo          ; обновить текущее представление
    (kbd "g") 'org-agenda-redo-all)     ; обновить все

  ;; В normal state (если вдруг переключишься) тоже будут работать
  (evil-define-key 'normal org-agenda-mode-map
    (kbd "t") 'org-agenda-todo
    (kbd "I") 'org-agenda-clock-in
    (kbd "O") 'org-agenda-clock-out
    (kbd "s") 'org-agenda-schedule
    (kbd "d") 'org-agenda-deadline
    (kbd "c") 'org-capture
    (kbd "q") 'org-agenda-quit
    (kbd "r") 'org-agenda-redo
    (kbd "g") 'org-agenda-redo-all))
(provide 'setup-agenda) ;; Если вынес в отдельный файл
