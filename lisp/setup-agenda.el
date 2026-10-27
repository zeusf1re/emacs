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

;; 1. Вспомогательная функция для выбора узла (как раньше, но с защитой от nil)
(defun my/org-roam-read-node-by-tag (tag)
  "Выбрать узел org-roam только с TAG (без открытия файла)."
  (let* ((nodes (seq-filter (lambda (n) (member tag (org-roam-node-tags n)))
                            (org-roam-node-list)))
         (completions (mapcar (lambda (n) (cons (org-roam-node-title n) n)) nodes)))
    (unless nodes
      (user-error "Не найдено ни одного узла с тегом '%s'" tag))
    (let ((choice (completing-read (format "Node (%s): " tag) completions nil t)))
      (cdr (assoc choice completions)))))

(defun my/org-roam-uni-target ()
  "Запросить узел с тегом discipline и вернуть путь к его файлу."
  (let* ((node (my/org-roam-read-node-by-tag "discipline"))
         (file (org-roam-node-file node)))
    (unless file
      (user-error "У выбранного узла нет привязанного файла"))
    file))

;; 3. Функция для перехода к первому заголовку (без изменений)
(defun my/goto-first-heading ()
  "Перейти к первому заголовку в текущем буфере."
  (goto-char (point-min))
  (if (re-search-forward org-outline-regexp-bol nil t)
      (goto-char (match-beginning 0))
    (goto-char (point-max))))

;; 4. Набор шаблонов
(defvar my/agenda-capture-templates
  '(("e" "Emacs Task" entry
     (file+headline "~/.config/emacs/plans.org" "Активные задачи")
     "** TODO %?\n")
    ("p" "Personal Task" entry
     (file "~/org/tasks.org")
     "* %?\n")
    ("u" "Uni Task" entry
     (file+function my/org-roam-uni-target my/goto-first-heading)
     "** TODO %?\n")))

;; 5. Обёртка, которая показывает меню выбора шаблонов
(defun my/agenda-capture-smart ()
  "Вызов org-capture с выбором одного из трёх шаблонов."
  (interactive)
  (let ((org-capture-templates my/agenda-capture-templates))
    (org-capture)))



(provide 'setup-agenda)
