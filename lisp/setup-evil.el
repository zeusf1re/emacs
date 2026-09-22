;; Evil (Vim layer)
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil) ;; Нужно для evil-collection
  :config
  (evil-mode 1))

;; Evil Collection (биндинги для всех плагинов, как в Doom)
(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-mode-list (remove 'dashboard evil-collection-mode-list))
  (evil-collection-init))

;; General (чтобы удобно биндить Space клавиши)
(use-package general
  :demand t
  :config
  (general-create-definer my-leader-def
    :prefix "SPC"
    :states '(normal visual motion)
    :keymaps 'override)
  
  (my-leader-def
    "b k" 'kill-current-buffer

    "." 'find-file
    "," 'consult-buffer
    ":" 'execute-extended-command ; M-x

    ;; Файлы (f)
    "f f" 'projectile-find-file
    "f r" 'consult-recent-file
    "f s" 'save-buffer

    ;; Буферы (b)
    "b b" 'switch-to-buffer ; или consult-buffer
    "b k" 'kill-current-buffer
    "b i" 'ibuffer
    "b B" 'ibuffer ; для совместимости

    ;; Окна (w)
    "w q" 'delete-window
    "w v" 'split-window-right
    "w s" 'split-window-below
    "w h" 'evil-window-left
    "w j" 'evil-window-down
    "w k" 'evil-window-up
    "w l" 'evil-window-right
    "w c" 'delete-window
    "w o" 'delete;; Управление размерами окон

    "w ." 'enlarge-window-horizontally  ; шире
    "w ," 'shrink-window-horizontally   ; уже
    "w +" 'enlarge-window               ; выше
    "w -" 'shrink-window                ; ниже-other-windows

    ;; Emacs (q)
    "q q" 'evil-quit-all
    "q f" 'delete-frame

    "f s" 'consult-ripgrep      ; Искать текст в проекте (нужен ripgrep в системе!)
    "f g" 'consult-ripgrep      ; Искать текст в проекте (нужен ripgrep в системе!)
    "s f" 'consult-find         ; Искать файлы (через find/fd)
    
    ;; Проекты (Project)
    "p p" 'projectile-switch-project
    "p f" 'projectile-find-file ; Поиск файлов ВНУТРИ проекта (как Telescope git_files)
    "SPC" 'find-file

    "t t" 'vterm ; Откроет vterm как обычный буфер (на весь экран, если одно окно)
    "f p" (lambda () (interactive) (find-file "~/.config/emacs/init.el"))

    "c a" 'lsp-execute-code-action  ; Code Action (меню с вариантами)
    "c r" 'lsp-rename              ; Rename variable
    "g d" 'lsp-find-references

    "c c" 'compile

    "/"   'consult-line

    "m u" 'mc/keyboard-quit
    "m n" 'mc/mark-next-like-this
    "m p" 'mc/mark-previous-like-this  ;; Выделить предыдущее
    "m a" 'mc/mark-all-like-this     ;; Выделить ВСЕ такие слова в буфере
    "m v" 'mc/edit-lines       ;; Создать курсоры на каждой строке выделения

    "a c" 'calfw-org-open-calendar;; Open Calendar
    "a a" 'org-agenda
    "a d" 'org-timestamp;;

    "h b" 'describe-bindings
    "h k" 'describe-key
    "h m" 'describe-mode

    "o l" 'org-latex-preview
    "o L" 'my/org-latex-preview-all

    "d"   'dired
   
    )
  )
(defun my-evil-syntax-fix ()
  (modify-syntax-entry ?_ "w") ; _ теперь часть слова (как в Vim)
  (modify-syntax-entry ?- "w")) ; - теперь пунктуация (разделитель)

;; Применяем это к prog-mode (код) и text-mode
(add-hook 'prog-mode-hook 'my-evil-syntax-fix)
(add-hook 'text-mode-hook 'my-evil-syntax-fix)

(with-eval-after-load 'dired
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-up-directory
    "l" 'dired-find-file))
(defun my/dired-evil-bindings ()
  (evil-define-key 'normal dired-mode-map
    "h" 'dired-up-directory
    "a" 'dired-create-empty-file
    "l" 'dired-find-file))
(add-hook 'dired-mode-hook #'my/dired-evil-bindings)


(global-set-key [escape] 'keyboard-escape-quit)

;; Или более жестко (через general):
;;(general-def
;;  :keymaps '(minibuffer-local-map
;;             minibuffer-local-ns-map
;;             minibuffer-local-completion-map
;;             minibuffer-local-must-match-map
;;             isearch-mode-map)
;;  "<escape>" 'abort-recursive-edit) ; Закрыть меню/поиск
;;(setq evil-collection-mode-list (remove 'dashboard evil-collection-mode-list))

(provide 'setup-evil)
