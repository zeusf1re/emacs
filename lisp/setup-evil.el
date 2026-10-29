(use-package evil
  :ensure t
  :demand t
  :init
  (setq evil-want-integration t)
  (setq evil-respect-visual-line-mode t)
  (setq evil-want-keybinding nil) 
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-mode-list (remove 'dashboard evil-collection-mode-list))
  (evil-collection-init))

(use-package general
  :demand t
  :config
  (general-create-definer my-leader-def
    :prefix "SPC"
    :states '(normal visual motion)
    :keymaps 'override)
  
  (my-leader-def
    "." 'find-file
    "," 'consult-buffer
    ":" 'execute-extended-command


    "b b" 'switch-to-buffer
    "b k" 'kill-current-buffer
    "b i" 'ibuffer
    "b B" 'ibuffer

    "w q" 'delete-window
    "w v" 'split-window-right
    "w s" 'split-window-below
    "w h" 'evil-window-left
    "w j" 'evil-window-down
    "w k" 'evil-window-up
    "w l" 'evil-window-right
    "w c" 'delete-window
    "w o" 'delete

    "w ." 'enlarge-window-horizontally
    "w ," 'shrink-window-horizontally
    "w +" 'enlarge-window
    "w -" 'shrink-window

    "q q" 'save-buffers-kill-emacs

    "f g" 'consult-find
    "f s" 'consult-ripgrep

    "p p" 'projectile-switch-project
    "p f" 'projectile-find-file

    "t t" 'vterm
    "f p" (lambda () (interactive) (find-file "~/.config/emacs/init.el"))

    "c a" 'lsp-execute-code-action
    "c r" 'lsp-rename
    "c e" 'lsp-ui-doc-show
    "c g d" 'lsp-find-references

    "c c" 'compile

    "/"   'consult-line

    "a c" 'calfw-org-open-calendar
    "a a" 'org-agenda
    "a t" 'org-timestamp
    "a d" 'org-deadline
    "a s" 'org-schedule
    "a i" 'org-clock-in
    "a o" 'org-clock-out
    "a l" 'org-clock-in-last
    "a n" 'org-add-note
    "a q" 'org-set-tags-command
    "a k" 'my/agenda-capture-smart

    "h b" 'describe-bindings
    "h k" 'describe-key
    "h m" 'describe-mode
    "h v" 'describe-variable
    "h f" 'describe-function
    "h s" 'describe-face

    "o l" 'org-latex-preview
    "o L" 'my/org-latex-preview-all

    "d"   'dashboard-open

    "m s" 'magit-status
    "g s" 'magit-status
    "m k" 'my/kill-all-magit-buffers

    "r f f" 'org-roam-node-find
    "r f t" 'my/org-roam-node-find-by-tag
    "r i" 'org-roam-node-insert
    "r I" 'org-roam-node-insert-immediate
    "r c" 'org-roam-capture
    "r l" 'org-roam-buffer-toggle
    "r D" 'org-roam-dailies-capture-today
    ;;"r d" 'org-roam-dailies-goto-today
    "r d d" 'org-roam-dailies-goto-today
    "r d t" 'org-roam-dailies-goto-tomorrow
    "r d y" 'org-roam-dailies-goto-yesterday
    "r d D" 'org-roam-dailies-capture-today
    "r d T" 'org-roam-dailies-capture-tomorrow
    "r d Y" 'org-roam-dailies-capture-yesterday
    "r t" 'org-roam-tag-add
    "r g " 'org-roam-graph
    "r u" 'org-roam-ui-open
    "r k" 'my/kill-org-roam-buffers
    ))
(defun my-evil-syntax-fix ()
  (modify-syntax-entry ?_ "w")
  (modify-syntax-entry ?- "w"))

(add-hook 'prog-mode-hook 'my-evil-syntax-fix)
(add-hook 'text-mode-hook 'my-evil-syntax-fix)

(global-set-key [escape] 'keyboard-escape-quit)

(use-package evil-commentary
  :ensure t
  :after evil
  :config
  (evil-commentary-mode 1))

(provide 'setup-evil)
