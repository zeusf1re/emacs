;;; setup-kakoune.el --- Kakoune-style modal editing (kakoune.el) -*- lexical-binding: t; -*-

;; kakoune.el — поверхностная симуляция Kakoune поверх ryo-modal-mode,
;; multiple-cursors.el и expand-region. Нормальный режим = ryo-modal-mode
;; включён; режим вставки = ryo-modal-mode выключен (клавиши вставки не
;; переопределяются вовсе, как в оригинальном Kakoune).

(defun my/find-init-file ()
  "Открыть init.el."
  (interactive)
  (find-file (expand-file-name "init.el" user-emacs-directory)))

(defun my/ryo-enter-normal ()
  "Войти в нормальный режим Kakoune."
  (interactive)
  (ryo-modal-mode 1))

(use-package kakoune
  :ensure t
  :config
  ;; 1. Базовые клавиши Kakoune — СНАЧАЛА, чтобы наши переопределения ниже
  ;;    имели приоритет. Даёт: hjkl, g-префикс (g g — начало буфера,
  ;;    g h/l — начало/конец строки, G — расширение выделения и т.д.),
  ;;    a/A/i/I/o/O, d/c/y/p, f/F/t/T, w/W/b/B, x/X, s/S (multiple-cursors).
  ;;    Внимание: в kakoune.el «G» — это префикс (как «g»), а не «конец
  ;;    буфера»: конец буфера — «G j» (или «g j»).
  (kakoune-setup-keybinds)

  (setq ryo-modal-cursor-type 'box)

  ;; 2. ESC — всегда в нормальный режим (в настоящем Kakoune ESC = normal).
  ;;    В vterm это не мешает: там [escape] сам вяжет vterm--self-insert.
  (global-set-key (kbd "<escape>") #'my/ryo-enter-normal)

  ;; 3. Нормальный режим по хукам (вместо списка начальных состояний).
  ;;    text-mode покрывает org-mode и typst-mode (наследуют text-mode),
  ;;    prog-mode — C/C++/Python/emacs-lisp и т.д.
  (add-hook 'prog-mode-hook #'my/ryo-enter-normal)
  (add-hook 'text-mode-hook #'my/ryo-enter-normal)
  (add-hook 'conf-mode-hook #'my/ryo-enter-normal)
  ;; НЕ включаем ryo-modal-mode (работают штатные клавиши режима):
  ;;   magit-mode, dired-mode/dirvish-mode, org-agenda-mode,
  ;;   pdf-view-mode, calfw-calendar-mode, help-mode, vterm-mode.
  ;; Помните: в отличие от «motion state» прежней настройки, в этих
  ;; режимах líder SPC теперь недоступен (нет ryo-modal-mode) —
  ;; только собственные клавиши режима.

  ;; 4. Дополнения поверх kakoune.el (ТОЛЬКО после kakoune-setup-keybinds!).
  (ryo-modal-keys
   ;; Undo/redo — в kakoune.el их нет (рекомендация из его README).
   ("u" undo)
   ("U" undo-redo)
   ;; v — расширение выделения (в оригинальном Kakoune; в kakoune.el
   ;; по умолчанию «v» не биндится вовсе).
   ("v" er/expand-region)
   ;; LSP: перенесено из lsp-mode-map — иначе префикс «g» из kakoune.el
   ;; делает «g d»/«g r» недостижимыми, а «K» перекрывается биндингом
   ;; kakoune.el. В режиме вставки эти клавиши снова печатаются как буквы.
   ("g d" lsp-find-definition)
   ("g r" lsp-find-references)
   ("K"   lsp-ui-doc-show)
   ;; org: «t» — статус TODO в нормальном режиме (в режиме вставки
   ;; буква «t» печатается нормально — баг org-mode-map больше не мешает).
   ("t" org-todo :mode 'org-mode))

  ;; 5. Leader SPC — все прежние лидер-биндинги.
  (ryo-modal-keys
   ("SPC"
    (("." find-file)
     ("," consult-buffer)
     (":" execute-extended-command)

     ;; Буферы и окна
     ("b" (("b" switch-to-buffer)
           ("k" kill-current-buffer)
           ("i" ibuffer)))
     ("w" (("q" delete-window)
           ("v" split-window-right)
           ("s" split-window-below)
           ("h" windmove-left)
           ("j" windmove-down)
           ("k" windmove-up)
           ("l" windmove-right)
           ("." enlarge-window-horizontally)
           ("," shrink-window-horizontally)
           ("+" enlarge-window)
           ("-" shrink-window)))
     ("q" (("q" save-buffers-kill-emacs)))

     ;; Проекты и поиск
     ("f" (("g" consult-find)
           ("s" consult-ripgrep)
           ("p" my/find-init-file)))
     ("p" (("p" projectile-switch-project)
           ("f" projectile-find-file)))

     ;; Терминал
     ("t" (("t" vterm)))

     ;; LSP / компиляция
     ("c" (("a" lsp-execute-code-action)
           ("r" lsp-rename)
           ("e" lsp-ui-doc-show)
           ("g" (("d" lsp-find-references)))
           ("c" compile)))

     ;; Поиск по строке / справка по клавишам
     ("/" consult-line)
     ("?" ryo-modal-bindings)

     ;; Typst
     ("m" (("c" my/typst-compile)
           ("p" my/typst-live-preview)
           ("s" my/typst-stop-preview)
           ("r" my/typst--refresh-pdf)))

     ;; Agenda / Org
     ("a" (("c" calfw-org-open-calendar)
           ("a" org-agenda)
           ("t" org-timestamp)
           ("d" org-deadline)
           ("s" org-schedule)
           ("i" org-clock-in)
           ("o" org-clock-out)
           ("l" org-clock-in-last)
           ("n" org-add-note)
           ("q" org-set-tags-command)))

     ;; Help
     ("h" (("b" describe-bindings)
           ("k" describe-key)
           ("m" describe-mode)
           ("v" describe-variable)
           ("f" describe-function)
           ("s" describe-face)))

     ;; Прочее
     ("o" (("l" org-latex-preview)
           ("L" my/org-latex-preview-all)))
     ("d" dashboard-open)

     ;; Git
     ("g" (("s" magit-status)
           ("k" magit-status)))

     ;; Org-roam
     ("r" (("f" (("f" org-roam-node-find)
                 ("t" my/org-roam-node-find-by-tag)))
           ("i" org-roam-node-insert)
           ("I" org-roam-node-insert-immediate)
           ("c" org-roam-capture)
           ("l" org-roam-buffer-toggle)
           ("D" org-roam-dailies-capture-today)
           ("d" (("d" org-roam-dailies-goto-today)
                 ("t" org-roam-dailies-goto-tomorrow)
                 ("y" org-roam-dailies-goto-yesterday)
                 ("D" org-roam-dailies-capture-today)
                 ("T" org-roam-dailies-capture-tomorrow)
                 ("Y" org-roam-dailies-capture-yesterday)))
           ("t" org-roam-tag-add)
           ("g" org-roam-graph)
           ("u" org-roam-ui-open)
           ("k" my/kill-org-roam-buffers)))))))

(provide 'setup-kakoune)
