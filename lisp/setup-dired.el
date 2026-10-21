;;; setup-dired.el --- Dired + Dirvish -*- lexical-binding: t; -*-

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

  ;; ---- биндинги для dirvish ----
  (define-key dirvish-mode-map (kbd "n")  #'isearch-forward)
  (define-key dirvish-mode-map (kbd "N")  #'isearch-backward)
  (define-key dirvish-mode-map (kbd "G")  #'end-of-buffer)
  (define-key dirvish-mode-map (kbd "gg") #'beginning-of-buffer))

;; ---- биндинги для классического dired ----
(defun my/dired-keys ()
  "Мои кастомные биндинги для dired."
  (define-key dired-mode-map (kbd "h") #'dired-up-directory)
  (define-key dired-mode-map (kbd "l") #'dired-find-file)
  (define-key dired-mode-map (kbd "a") #'dired-create-empty-file)
  (define-key dired-mode-map (kbd "A") #'dired-create-directory)
  (define-key dired-mode-map (kbd "c") #'dired-ranger-copy)
  (define-key dired-mode-map (kbd "M") #'dired-ranger-move)
  (define-key dired-mode-map (kbd "p") #'dired-ranger-paste)
  (define-key dired-mode-map (kbd "d") #'dired-do-delete)
  (define-key dired-mode-map (kbd "i") #'wdired-change-to-wdired-mode)
  (define-key dired-mode-map (kbd "m") #'dired-mark))

(add-hook 'dired-mode-hook #'my/dired-keys)

;; ---- dired настройки ----
(setq dired-listing-switches
      "-l --almost-all --human-readable --time-style=long-iso --group-directories-first --no-group")

(setq dirvish-header-line-format '(:left (path) :right (free-space)))
(setq dirvish-hide-cursor t)

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
(setq delete-by-moving-to-trash t)
(provide 'setup-dired)
