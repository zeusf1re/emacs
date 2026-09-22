
;; ~/.config/emacs/lisp/setup-completion.el

;; Vertico (UI для поиска - аналог Telescope dropdown)
(use-package vertico
  :init (vertico-mode)
  :bind (:map vertico-map
              ("DEL" . vertico-directory-delete-char) ; Удалить символ (или путь, если курсор в конце)
              ("C-<backspace>" . vertico-directory-up))) ; Ctrl+Backspace - на уровень вверх
;; На самом деле vertico-directory-delete-char "умный":
;; если ты в конце пути "foo/bar/", он удалит "bar/".
;; Нужно просто подключить расширение.

(use-package vertico-directory
  :after vertico
  :ensure nil ;; Это часть пакета vertico, не качать отдельно
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word)))

;; Consult (Команды поиска - аналог Telescope builtin)

;; Orderless (Умный поиск: "file name" найдет "name_file")
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Marginalia (Описания справа в меню поиска)
(use-package marginalia
  :init (marginalia-mode))

;; Corfu (Автодополнение в коде - аналог nvim-cmp)
(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)        ;; Авто-показ
  (corfu-auto-delay 0)  ;; Без задержки
  (corfu-auto-prefix 1))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer))
  :config
  ;; Включаем автоматическое превью для всего (с небольшой задержкой, чтобы не лагало)
  (consult-customize
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-buffer
   :preview-key '(:debounce 0.2 any)) ;; 0.2 сек задержка, любая клавиша обновляет превью

  (add-to-list 'consult-buffer-filter "^\\*clang") ; Скрыть *clang...*
  (add-to-list 'consult-buffer-filter "^\\*EGLOT") ; Скрыть *EGLOT...*
  (add-to-list 'consult-buffer-filter "^\\*Flycheck") ; Скрыть *Flycheck...*
  (add-to-list 'consult-buffer-filter "^\\*Epil") ; И прочий шум
  (add-to-list 'consult-buffer-filter "^\\*Async") ; И прочий шум
  (add-to-list 'consult-buffer-filter "^\\*elpaca") ; И прочий шум
  (add-to-list 'consult-buffer-filter "^\\*xref") ; И прочий шум
)

(provide 'setup-completion)
