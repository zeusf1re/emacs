;;; setup-magit.el --- Magit configuration -*- lexical-binding: t; -*-

(defun my/magit-display-buffer (buffer)
  "Display BUFFER for Magit.
Diff/log/revision buffers open in a window at the bottom of the
selected frame; everything else opens in the selected window.
Uses `split-window-below' directly so it is not affected by the
`split-window-sensibly' advice in `setup-ui.el'."
  (if (with-current-buffer buffer
        (derived-mode-p 'magit-diff-mode
                        'magit-revision-mode
                        'magit-log-mode))
      (let ((win (get-buffer-window buffer)))
        (unless (window-live-p win)
          (let* ((total (window-height (selected-window)))
                 (size  (max 10 (round (* 0.4 total)))))
            (setq win (split-window-below size))
            ;; помечаем: это окно создали мы, при bury его надо убить
            (set-window-parameter win 'my/magit-popup t)))
        (set-window-buffer win buffer)
        (select-window win)
        win)
    (display-buffer buffer '(display-buffer-same-window))))

(defun my/magit-bury-a (orig &rest args)
  "Run ORIG (bury), then delete the popup window we created for it."
  (let ((win (selected-window)))
    (prog1 (apply orig args)
      (when (and (window-live-p win)
                 (window-parameter win 'my/magit-popup)
                 (not (one-window-p)))
        (delete-window win)))))

(advice-add 'magit-mode-bury-buffer :around #'my/magit-bury-a)

(use-package magit
  :ensure t
  :bind (("C-x g"   . magit-status)
         ("C-x M-g" . magit-dispatch))
  :config
  (setq magit-display-buffer-function #'my/magit-display-buffer))

(provide 'setup-magit)
