;;; setup-meow.el --- Modal editing with Meow -*- lexical-binding: t; -*-

(defun my/find-init-file ()
  "Открыть init.el."
  (interactive)
  (find-file (expand-file-name "init.el" user-emacs-directory)))

(defun meow-setup ()
  "Раскладка Meow (QWERTY, из официальной документации)."
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore)))

(use-package meow
  :ensure t
  :config
  (meow-setup)

  ;; Глобальный режим Meow
  (meow-global-mode 1)

  ;; SPC — наш leader (mode-specific-map), а не встроенный keypad
  (define-key meow-normal-state-keymap (kbd "SPC") mode-specific-map)
  (define-key meow-motion-state-keymap (kbd "SPC") mode-specific-map)

  ;; Leader-меню (SPC ...)
  (meow-leader-define-key
   '("." . find-file)
   '("," . consult-buffer)
   '(":" . execute-extended-command)

   ;; Буферы и окна
   '("b b" . switch-to-buffer)
   '("b k" . kill-current-buffer)
   '("b i" . ibuffer)

   '("w q" . delete-window)
   '("w v" . split-window-right)
   '("w s" . split-window-below)
   '("w h" . windmove-left)
   '("w j" . windmove-down)
   '("w k" . windmove-up)
   '("w l" . windmove-right)

   '("w ." . enlarge-window-horizontally)
   '("w ," . shrink-window-horizontally)
   '("w +" . enlarge-window)
   '("w -" . shrink-window)

   '("q q" . save-buffers-kill-emacs)

   ;; Проекты и поиск
   '("f g" . consult-find)
   '("f s" . consult-ripgrep)
   '("p p" . projectile-switch-project)
   '("p f" . projectile-find-file)

   ;; Терминал и конфиг
   '("t t" . vterm)
   '("f p" . my/find-init-file)

   ;; LSP
   '("c a" . lsp-execute-code-action)
   '("c r" . lsp-rename)
   '("c e" . lsp-ui-doc-show)
   '("c g d" . lsp-find-references)
   '("c c" . compile)

   ;; Поиск по строке
   '("/" . consult-line)
   '("?" . meow-cheatsheet)

   ;; Typst
   '("m c" . my/typst-compile)
   '("m p" . my/typst-live-preview)
   '("m s" . my/typst-stop-preview)
   '("m r" . my/typst--refresh-pdf)

   ;; Agenda / Org
   '("a c" . calfw-org-open-calendar)
   '("a a" . org-agenda)
   '("a t" . org-timestamp)
   '("a d" . org-deadline)
   '("a s" . org-schedule)
   '("a i" . org-clock-in)
   '("a o" . org-clock-out)
   '("a l" . org-clock-in-last)
   '("a n" . org-add-note)
   '("a q" . org-set-tags-command)

   ;; Help
   '("h b" . describe-bindings)
   '("h k" . describe-key)
   '("h m" . describe-mode)
   '("h v" . describe-variable)
   '("h f" . describe-function)
   '("h s" . describe-face)

   ;; Прочее
   '("o l" . org-latex-preview)
   '("o L" . my/org-latex-preview-all)
   '("d" . dashboard-open)

   ;; Git
   '("g s" . magit-status)
   '("g k" . magit-status)

   ;; Org-roam
   '("r f f" . org-roam-node-find)
   '("r f t" . my/org-roam-node-find-by-tag)
   '("r i" . org-roam-node-insert)
   '("r I" . org-roam-node-insert-immediate)
   '("r c" . org-roam-capture)
   '("r l" . org-roam-buffer-toggle)
   '("r D" . org-roam-dailies-capture-today)
   '("r d d" . org-roam-dailies-goto-today)
   '("r d t" . org-roam-dailies-goto-tomorrow)
   '("r d y" . org-roam-dailies-goto-yesterday)
   '("r d D" . org-roam-dailies-capture-today)
   '("r d T" . org-roam-dailies-capture-tomorrow)
   '("r d Y" . org-roam-dailies-capture-yesterday)
   '("r t" . org-roam-tag-add)
   '("r g" . org-roam-graph)
   '("r u" . org-roam-ui-open)
   '("r k" . my/kill-org-roam-buffers)
   ))

;; Начальные состояния для режимов
(setq meow-mode-state-list
      '((fundamental-mode . normal)
        (text-mode . normal)
        (prog-mode . normal)
        (conf-mode . normal)
        (org-mode . normal)
        (emacs-lisp-mode . normal)
        (help-mode . motion)
        (dired-mode . motion)
        (dirvish-mode . motion)
        (magit-mode . motion)
        (pdf-view-mode . motion)
        (org-agenda-mode . motion)
        (calfw-calendar-mode . motion)
        (vterm-mode . insert)))

(provide 'setup-meow)
