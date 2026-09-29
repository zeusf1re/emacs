

(setq ns-use-native-fullscreen t)

(defun my/frame-maximize (frame)
  "Полный fullscreen FRAME при создании."
  (when (display-graphic-p frame)
    (set-frame-parameter frame 'fullscreen 'fullscreen)))
(add-hook 'after-make-frame-functions #'my/frame-maximize)
(my/frame-maximize (selected-frame))

(set-face-attribute 'default nil :font "FiraCode Nerd Font Mono" :height 200)

(use-package kanagawa-themes
  :config
  (load-theme 'kanagawa-wave t)
  
    (set-face-attribute 'header-line nil :background nil :inherit 'default)
  
    (with-eval-after-load 'lsp-headerline
    (set-face-attribute 'lsp-headerline-breadcrumb-separator-face nil :background nil)
    (set-face-attribute 'lsp-headerline-breadcrumb-path-face nil :background nil :weight 'bold)
    (set-face-attribute 'lsp-headerline-breadcrumb-symbols-face nil :background nil :weight 'bold)))
(use-package nerd-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 35))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package transient
  :ensure t)
(setq scroll-margin 2
      scroll-conservatively 101
      scroll-preserve-screen-position t)

(add-to-list 'default-frame-alist '(fullscreen . fullscreen))
(provide 'setup-ui)
