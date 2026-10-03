

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



(setq scroll-margin 2
      scroll-conservatively 101
      scroll-preserve-screen-position t)

(defvar my/popup-whitelist
  '("\\*Help\\*" "\\*Calculator\\*" "\\*Calc\\*" "\\*Calc Trail\\*"
    "\\*Completions\\*" "\\*compilation\\*" "\\*Occur\\*" "\\*grep\\*"
    "\\*vc-.*\\*" "\\*Messages\\*" "\\*Warnings\\*"
    "\\*Shell Command Output\\*")
  "Buffers matching these regexps may open in another window / split.")

(defun my/display-buffer-no-split (orig buffer-or-name &optional action frame)
  "Force display-buffer to reuse current window unless whitelisted."
  (let* ((name (if (bufferp buffer-or-name)
                   (buffer-name buffer-or-name)
                 (format "%s" buffer-or-name)))
         (whitelisted (seq-some (lambda (re) (string-match-p re name))
                                my/popup-whitelist)))
    (funcall orig buffer-or-name
             (if whitelisted
                 action
               '(display-buffer-reuse-window display-buffer-same-window))
             frame)))

(advice-add 'display-buffer :around #'my/display-buffer-no-split)
;; ---- popup policy ----
(defun my/no-auto-split (&rest _) nil)
(advice-add 'split-window-sensibly :override #'my/no-auto-split)
(advice-add 'display-buffer :around #'my/display-buffer-no-split)
(setq kill-buffer-query-functions nil)
(setq kill-buffer-delete-auto-save-files nil)


(setq confirm-kill-emacs nil          ; don't ask "really quit?"
      kill-buffer-quit-windows nil
      confirm-nonexistent-file-or-buffer nil
      org-confirm-babel-evaluate nil  ; don't ask before running src blocks
      use-short-answers t)            ; y/n instead of yes/no





;; "K"
(add-to-list 'display-buffer-alist
             '("\\*lsp-help\\*"
               (display-buffer-in-side-window)
               (side . right)
               (slot . -1)              ; -1 = верхний слот среди right-side окон
               (window-width . 0.35)))
(advice-add 'lsp-describe-thing-at-point :after
            (lambda (&rest _)
              (when-let ((win (get-buffer-window "*lsp-help*")))
                (select-window win))))
(provide 'setup-ui)

