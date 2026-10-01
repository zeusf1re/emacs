(use-package dired-ranger
  :ensure t
  :defer t)

(defun my/dired-evil-bindings ()
  "Мои кастомные биндинги для dired в evil-mode."
  (interactive)
  (evil-define-key 'normal dired-mode-map
    ;; Навигация
    "h" 'dired-up-directory
    "l" 'dired-find-file
    ;; "j" и "k" уже работают по умолчанию в evil

    ;; Создание файлов и директорий
    "a" 'dired-create-empty-file
    "A" 'dired-create-directory

    ;; Dired-ranger: копирование / перемещение / вставка
    "c" 'dired-ranger-copy
    "M" 'dired-ranger-move
    "p" 'dired-ranger-paste

    ;; Удаление (стандартный dired, помечает файлы на удаление)
    "d" 'dired-do-delete

    ;; Вход в режим редактирования имён (wdired)
    "i" 'wdired-change-to-wdired-mode)

  ;; Маркировка: m работает и в normal, и в visual
  (evil-define-key 'normal dired-mode-map
    "m" 'dired-mark)
  (evil-define-key 'visual dired-mode-map
    "m" 'dired-mark))

(add-hook 'dired-mode-hook #'my/dired-evil-bindings)

;;(dirvish-override-dired-mode -1)
;;(when (bound-and-true-p dirvish-mode)            to disable dirvish-trash
;;  (dirvish-mode -1))
(use-package dirvish
  :ensure t
  :init
  (dirvish-override-dired-mode)
  :config
  ;; Атрибуты файлов
  (setq dirvish-attributes '(nerd-icons vc-state file-size file-time))
  (setq dirvish-subtree-state-style 'nerd)
  (setq dirvish-path-separators '("  " "  " "  ")

    )

    (evil-define-key 'normal dirvish-mode-map
    "n" 'evil-search-next
    "N" 'evil-search-previous)

  ;; Переключение сортировки по "O"
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

  ;; Интеграция с fd (если установлен)
  (when (executable-find "fd")
    (require 'dirvish-fd nil t)))


(setq dired-listing-switches "-l --almost-all --human-readable --time-style=long-iso --group-directories-first --no-group")

(setq dirvish-header-line-format '(:left (path) :right (free-space)))

(evil-make-overriding-map dirvish-mode-map 'normal)
(setq dirvish-hide-cursor t)
(add-hook 'dired-mode-hook (lambda () (setq-local evil-normal-state-cursor nil)))

;;(setq dirvish-header-line-format '(:left (:eval (expand-file-name default-directory)) :right (free-space)))
(setq dirvish-use-header-line 'global)     




; Placement
;; (setq dirvish-use-mode-line nil)        ; hide mode line
(setq dirvish-use-header-line 'global)     ; make header line span all panes
(setq dirvish-mode-line-bar-image-width 0) ; hide the leading bar image
(setq dirvish-use-header-line nil)      ; hide header line (show the classic dired header)

;; Height
;;; '(25 . 35) means
;;;   - height in single window sessions is 25
;;;   - height in full-frame sessions is 35
(setq dirvish-header-line-height '(25 . 35))
(setq dirvish-mode-line-height 25) ; shorthand for '(25 . 25)

;; Segments
;;; 1. the order of segments *matters* here
;;; 2. it's ok to place raw strings in it as separators
(setq dirvish-header-line-format
      '(:left (path) :right (free-space))
      dirvish-mode-line-format
      '(:left (sort file-time " " file-size symlink) :right (omit yank index)))

(with-eval-after-load 'dirvish
  (evil-define-key 'normal dirvish-mode-map
    "n" 'evil-ex-search-next
    "N" 'evil-ex-search-previous))
(with-eval-after-load 'dirvish
  (evil-define-key 'normal dirvish-mode-map
    "G" 'end-of-buffer
    "gg" 'evil-goto-first-line))
;; Опционально: отдельный use-package для fd-расширения
(use-package dirvish-fd
  :ensure t
  :after dirvish
  :config
  (setq dirvish-fd-switches ""))
(blink-cursor-mode -1)
(provide 'setup-dired)
