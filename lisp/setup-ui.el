
;; ~/.config/emacs/lisp/setup-ui.el

;; macOS: нативный fullscreen (F11) + максимизация при создании фрейма
(setq ns-use-native-fullscreen t)
(defun my/frame-maximize (frame)
  "Максимизировать FRAME при создании (нужно для emacsclient)."
  (when (display-graphic-p frame)
    (set-frame-parameter frame 'fullscreen 'maximized)))
(add-hook 'after-make-frame-functions #'my/frame-maximize)
(my/frame-maximize (selected-frame))

;; Шрифты
(set-face-attribute 'default nil :font "FiraCode Nerd Font Mono" :height 200)

;; Тема Kanagawa
(use-package kanagawa-themes
  :config
  (load-theme 'kanagawa-wave t)
  
  ;; Убираем фон у Header Line (сверху)
  (set-face-attribute 'header-line nil :background nil :inherit 'default)
  
  ;; И на всякий случай для LSP breadcrumb (если они используют свои faces)
  (with-eval-after-load 'lsp-headerline
    (set-face-attribute 'lsp-headerline-breadcrumb-separator-face nil :background nil)
    (set-face-attribute 'lsp-headerline-breadcrumb-path-face nil :background nil :weight 'bold)
    (set-face-attribute 'lsp-headerline-breadcrumb-symbols-face nil :background nil :weight 'bold)))
;; Nerd Icons (нужны для Doom-modeline)
(use-package nerd-icons)

;; Doom Modeline (красивая полоска внизу)
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 35))

;; Радужные скобочки
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package transient
  :ensure t
  :config
  ;; Если нужно, можно добавить настройки
  )
;; Плавный скроллинг по 1 строке, когда курсор у края
(setq scroll-margin 2              ; Начинать скроллить за 4 строки до края (как scrolloff в Vim)
      scroll-conservatively 101    ; Никогда не центрировать экран, просто сдвигать
      scroll-preserve-screen-position t) ; Сохранять позицию курсора при PageUp/Down
;; Включаем поддержку нативного полноэкранного режима macOS (рекомендуется)
(setq ns-use-native-fullscreen t)

;; Устанавливаем полноэкранный режим для всех новых окон (фреймов)
(add-to-list 'default-frame-alist '(fullscreen . fullscreen))
(provide 'setup-ui)
