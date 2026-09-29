(use-package evil
  :init
  (setq evil-want-integration t)
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

    "q q" 'evil-quit-all

    "f g" 'consult-find
    "f s" 'consult-ripgrep

    "p p" 'projectile-switch-project
    "p f" 'projectile-find-file

    "t t" 'vterm
    "f p" (lambda () (interactive) (find-file "~/.config/emacs/init.el"))

    "c a" 'lsp-execute-code-action
    "c r" 'lsp-rename
    "c e" 'lsp-ui-doc-show
    "g d" 'lsp-find-references

    "c c" 'compile

    "/"   'consult-line

    "a c" 'calfw-org-open-calendar
    "a a" 'org-agenda
    "a d" 'org-timestamp
    "a i" 'org-clock-in
    "a o" 'org-clock-out
    "a l" 'org-clock-in-last


    "h b" 'describe-bindings
    "h k" 'describe-key
    "h m" 'describe-mode

    "o l" 'org-latex-preview
    "o L" 'my/org-latex-preview-all

    "d"   'dired))
(defun my-evil-syntax-fix ()
  (modify-syntax-entry ?_ "w")
  (modify-syntax-entry ?- "w"))

(add-hook 'prog-mode-hook 'my-evil-syntax-fix)
(add-hook 'text-mode-hook 'my-evil-syntax-fix)

;;(defun my/dired-evil-bindings ()
;;  (evil-define-key 'normal dired-mode-map
;;    "h" 'dired-up-directory
;;    "a" 'dired-create-empty-file
;;    "l" 'dired-find-file))
;;(add-hook 'dired-mode-hook #'my/dired-evil-bindings)

(global-set-key [escape] 'keyboard-escape-quit)

(provide 'setup-evil)
