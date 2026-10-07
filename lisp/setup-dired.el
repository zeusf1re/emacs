;;; setup-dired.el --- Dired + Dirvish + Evil -*- lexical-binding: t; -*-

(use-package dired-ranger
  :ensure t
  :defer t)

(use-package dirvish
  :ensure t
  :init
  (dirvish-override-dired-mode)
  :config
  ;; ---- внешний вид ----
  (setq dirvish-attributes '(nerd-icons vc-state file-size file-time))
  (setq dirvish-subtree-state-style 'nerd)
  (setq dirvish-path-separators '("  " "  " "  "))

  ;; ---- toggle-sort по "O" ----
  (defun my/dirvish-toggle-sort ()
    "Переключает сортировку Dirvish между лексикографической и по дате."
    (interactive)
    (let ((current (dired-get-filename nil t)))
      (if (string-match-p "time" (or dired-actual-switches ""))
          (dirvish-quicksort "name")
        (dirvish-quicksort "time"))
      (when current
        (dired-goto-file current))))

  (define-key dirvish-mode-map (kbd "O") #'my/dirvish-toggle-sort)

  ;; ---- fd ----
  (when (executable-find "fd")
    (require 'dirvish-fd nil t))

  ;; ---- evil-биндинги для dirvish ----
  (with-eval-after-load 'evil
    (evil-make-overriding-map dirvish-mode-map 'normal)
    (evil-define-key 'normal dirvish-mode-map
      "n"  'evil-ex-search-next
      "N"  'evil-ex-search-previous
      "G"  'end-of-buffer
      "gg" 'evil-goto-first-line)))

;; ---- биндинги для классического dired ----
(defun my/dired-evil-bindings ()
  "Мои кастомные биндинги для dired в evil-mode."
  (with-eval-after-load 'evil
    (evil-define-key 'normal dired-mode-map
      "h" 'dired-up-directory
      "l" 'dired-find-file
      "a" 'dired-create-empty-file
      "A" 'dired-create-directory
      "c" 'dired-ranger-copy
      "M" 'dired-ranger-move
      "p" 'dired-ranger-paste
      "d" 'dired-do-delete
      "i" 'wdired-change-to-wdired-mode
      "m" 'dired-mark)
    (evil-define-key 'visual dired-mode-map
      "m" 'dired-mark)))

(add-hook 'dired-mode-hook #'my/dired-evil-bindings)

;; ---- dired настройки ----
(setq dired-listing-switches
      "-l --almost-all --human-readable --time-style=long-iso --group-directories-first --no-group")

(setq dirvish-header-line-format '(:left (path) :right (free-space)))
(setq dirvish-hide-cursor t)
(add-hook 'dired-mode-hook (lambda () (setq-local evil-normal-state-cursor nil)))

(setq dirvish-use-header-line 'global)
(setq dirvish-mode-line-bar-image-width 0)
(setq dirvish-header-line-height '(25 . 35))
(setq dirvish-mode-line-height 25)
(setq dirvish-mode-line-format
      '(:left (sort file-time " " file-size symlink) :right (omit yank index)))

;; ---- БЕЗ ПОДТВЕРЖДЕНИЙ ----
;; dired: x → dired-do-flagged-delete
(setq dired-deletion-confirmer (lambda (_) t))
;; dired: d → dired-do-delete
(setq dired-no-confirm '(delete))
;; рекурсивные операции — молча
(setq dired-recursive-deletes 'always)
(setq dired-recursive-copies  'always)
;; ibuffer: x → ibuffer-do-delete
(setq ibuffer-confirm-operation-on nil)

(use-package dirvish-fd
  :ensure nil
  :after dirvish
  :config
  (setq dirvish-fd-switches ""))

(blink-cursor-mode -1)

(provide 'setup-dired)
