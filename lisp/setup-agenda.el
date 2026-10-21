;;; setup-agenda.el --- Org-agenda configuration -*- lexical-binding: t -*-

;; ====== Базовые настройки ======
(setq org-agenda-start-on-weekday nil)
(setq org-deadline-warning-days 1)
(setq org-agenda-hide-tags-regexp "discipline")
(setq org-agenda-current-time-string "")
(setq org-agenda-time-grid '((daily) () "" ""))
(setq calendar-week-start-day 1)

;; Защита от глубокой рекурсии в nerd-icons/all-the-icons
(setq max-lisp-eval-depth 10000)

;; ====== Обновление org-agenda-files ДО запуска ======
(with-eval-after-load 'org-agenda
  (defun my/refresh-agenda-files-before-agenda (&rest _)
    (when (fboundp 'my/org-roam-refresh-agenda-list)
      (my/org-roam-refresh-agenda-list)))
  (advice-add 'org-agenda :before #'my/refresh-agenda-files-before-agenda))

;; ====== Биндинги org-agenda ======
(defun my/setup-agenda-keys ()
  "Кастомные биндинги для `org-agenda-mode'."
  (define-key org-agenda-mode-map (kbd "h")   #'org-agenda-earlier)
  (define-key org-agenda-mode-map (kbd "l")   #'org-agenda-later)
  (define-key org-agenda-mode-map (kbd "j")   #'org-agenda-next-item)
  (define-key org-agenda-mode-map (kbd "k")   #'org-agenda-previous-item)
  (define-key org-agenda-mode-map (kbd "t")   #'org-agenda-todo)
  (define-key org-agenda-mode-map (kbd "I")   #'org-agenda-clock-in)
  (define-key org-agenda-mode-map (kbd "O")   #'org-agenda-clock-out)
  (define-key org-agenda-mode-map (kbd "s")   #'org-agenda-schedule)
  (define-key org-agenda-mode-map (kbd "d")   #'org-agenda-deadline)
  (define-key org-agenda-mode-map (kbd "c")   #'org-capture)
  (define-key org-agenda-mode-map (kbd "q")   #'org-agenda-quit)
  (define-key org-agenda-mode-map (kbd "r")   #'org-agenda-redo)
  (define-key org-agenda-mode-map (kbd "RET") #'org-agenda-switch-to))

(add-hook 'org-agenda-mode-hook #'my/setup-agenda-keys)

;; ====== Кастомные команды ======
(setq org-agenda-custom-commands
      '(("d" "📅 День"
         ((agenda ""
                  ((org-agenda-span 1)
                   (org-agenda-start-day nil)
                   (org-agenda-overriding-header "📅 Сегодня")))

          (agenda ""
                  ((org-agenda-span 2)
                   (org-agenda-start-day "+1")
                   (org-agenda-tag-filter-preset '("-event"))
                   (org-agenda-overriding-header "⏭️ Следующие 2 дня")))

          (todo "TODO"
                ((org-agenda-todo-ignore-scheduled nil)
                 (org-agenda-todo-ignore-deadlines nil)
                 (org-agenda-overriding-header "⏭️ Все TODO")))

          (tags "urgent"
                ((org-agenda-overriding-header "🔥 Urgent")))))

        ("e" "🛠️ Emacs Tasks"
         ((todo "TODO"
                ((org-agenda-files (list "~/.config/emacs/plans.org"))
                 (org-agenda-hide-tags-regexp (regexp-opt '("active" "emacs" "config")))
                 (org-agenda-overriding-header "Ongoing tasks")))))))

  (with-eval-after-load 'org-agenda
    (custom-set-faces
     ;; Заголовки

     ;; Статус DONE
     '(org-agenda-structure ((t (:foreground "#B8B4D0"))))
     '(default ((t (:foreground "#DCD7BA"))))
     '(org-agenda-done ((t (:foreground "#98BB6C"))))
     '(org-scheduled-today ((t (:foreground "#98BB6C"))))
     '(org-scheduled ((t (:foreground "#98BB6C"))))

     ))
(setq org-agenda-tags-column -110)
(provide 'setup-agenda)
