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

;; ====== Evil-org ======
(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;; ====== Evil-биндинги ======
(defun my/setup-agenda-evil-keys ()
  (evil-define-key 'motion org-agenda-mode-map
    (kbd "h")   'evil-backward-char
    (kbd "l")   'evil-forward-char
    (kbd "j")   'org-agenda-next-item
    (kbd "k")   'org-agenda-previous-item
    (kbd "t")   'org-agenda-todo
    (kbd "I")   'org-agenda-clock-in
    (kbd "O")   'org-agenda-clock-out
    (kbd "s")   'org-agenda-schedule
    (kbd "d")   'org-agenda-deadline
    (kbd "c")   'org-capture
    (kbd "q")   'org-agenda-quit
    (kbd "r")   'org-agenda-redo
    (kbd "RET") 'org-agenda-switch-to
    (kbd "/") 'org-agenda-filter-by-tag
    ))

(add-hook 'org-agenda-mode-hook #'my/setup-agenda-evil-keys)

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
(setq org-complete-tags-always-offer-all-agenda-tags t)
(setq org-agenda-tags-column -110)
(provide 'setup-agenda)
