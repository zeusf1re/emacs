(use-package vterm
  :ensure t
  :hook (vterm-mode . (lambda ()
                        (display-line-numbers-mode -1)
                        (setq-local global-hl-line-mode nil)))
  :config
  (setq vterm-max-scrollback 10000)

  ;; ГЛАВНЫЙ ФИКС ПРОБЕЛА
  ;; Мы говорим Evil: "В режиме vterm, когда мы в состоянии insert,
  ;; клавиша SPC должна вызывать vterm--self-insert (просто пробел), а не лидер".
  (evil-define-key 'insert vterm-mode-map (kbd "SPC") #'vterm--self-insert)
  (add-to-list 'consult-buffer-filter "^\\*clang") ; Скрыть *clang...*
  (add-to-list 'consult-buffer-filter "^\\*EGLOT") ; Скрыть *EGLOT...*
  (add-to-list 'consult-buffer-filter "^\\*Flycheck") ; Скрыть *Flycheck...*
  (add-to-list 'consult-buffer-filter "^\\*Epil") ; И прочий шум
  (add-to-list 'consult-buffer-filter "^\\*Async") ; И прочий шум
  (add-to-list 'consult-buffer-filter "^\\*elpaca") ; И прочий шум
  (add-to-list 'consult-buffer-filter "^\\*xref") ; И прочий шум
  )

(provide 'setup-term)

