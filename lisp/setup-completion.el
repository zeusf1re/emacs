;; ==========setup-completion.el==============

(use-package vertico
  :init (vertico-mode)
  :bind (:map vertico-map
              ("DEL" . vertico-directory-delete-char)
              ("C-<backspace>" . vertico-directory-up)))

(use-package vertico-directory
  :after vertico
  :ensure nil
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word)))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init (marginalia-mode))

;; ---------- CORFU ----------
(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 1)
  (corfu-cycle t)
  (corfu-preselect 'first)
  (corfu-quit-no-match 'separator)
  :bind (:map corfu-map
              ("RET" . nil)                ; <-- отвязать RET
              ("<return>" . nil)           ; <-- и на всякий случай
              ("TAB" . corfu-insert)         ; Tab — следующий
              ("<tab>" . corfu-insert)
              ("<backtab>" . corfu-previous) ; Shift-Tab — предыдущий
              ("S-TAB" . corfu-previous)))

;; Окошко с сигнатурой/докой под списком кандидатов
(use-package corfu-popupinfo
  :ensure nil                     ; идёт в комплекте с corfu, отдельно ставить не надо
  :after corfu
  :hook (corfu-mode . corfu-popupinfo-mode)
  :custom
  (corfu-popupinfo-delay '(0.2 . 0.1))
  (corfu-popupinfo-hide nil))     ; показывать сразу, не прятать

;; Иконки слева от кандидатов (F, V, M и т.д.)
(use-package kind-icon
  :ensure t
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default)
  (kind-icon-blend-background t)
  (kind-icon-use-icons t)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; ---------- CONSULT ----------
(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer))
  :config
  (consult-customize
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-buffer
   :preview-key '(:debounce 0.2 any))

  (add-to-list 'consult-buffer-filter "^\\*clang")
  (add-to-list 'consult-buffer-filter "^\\*EGLOT")
  (add-to-list 'consult-buffer-filter "^\\*Flycheck")
  (add-to-list 'consult-buffer-filter "^\\*Epil")
  (add-to-list 'consult-buffer-filter "^\\*Async")
  (add-to-list 'consult-buffer-filter "^\\*elpaca")
  (add-to-list 'consult-buffer-filter "^\\*xref"))
(use-package cape
  :ensure t)
(provide 'setup-completion)
