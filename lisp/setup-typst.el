
(use-package typst-mode
  :ensure (:type git :host github :repo "Ziqi-Yang/typst-mode.el")
  :mode "\\.typ\\'"
  :hook (typst-mode . my/typst--setup)
  :config
  (setq typst-executable-location "typst"))

(defun my/typst--setup ()
  "Local setup for `typst-mode'."
    (when (executable-find "tinymist")
    (lsp-deferred))
    (add-hook 'after-save-hook #'my/typst--refresh-preview nil t)
  (my/typst--bind-keys))

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration '(typst-mode . "typst"))
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection (lambda () (list "tinymist")))
    :major-modes '(typst-mode)
    :server-id 'tinymist
    :download-server-fn (lambda (_client _cb) nil))))

(defvar my/typst--watch-process nil)
(defvar my/typst--preview-buffer nil)
(defvar my/typst--notify-desc nil)
(defvar my/typst--fallback-timer nil)

(defun my/typst--pdf-file ()
  "Path to PDF for current buffer."
  (concat (file-name-sans-extension (buffer-file-name)) ".pdf"))

(defun my/typst--stop-watch ()
  "Stop running typst watch process."
  (when (and my/typst--watch-process
             (process-live-p my/typst--watch-process))
    (delete-process my/typst--watch-process))
  (setq my/typst--watch-process nil))

(defun my/typst--stop-notify ()
  "Remove file-notify watch and fallback timer on preview PDF."
  (when my/typst--notify-desc
    (ignore-errors (file-notify-rm-watch my/typst--notify-desc))
    (setq my/typst--notify-desc nil))
  (when my/typst--fallback-timer
    (cancel-timer my/typst--fallback-timer)
    (setq my/typst--fallback-timer nil)))

(defun my/typst--pdf-buffer ()
  "Return live PDF buffer for current file, if any."
  (when (buffer-live-p my/typst--preview-buffer)
    my/typst--preview-buffer))

(defun my/typst--refresh-pdf (&rest _)
  "Revert preview PDF buffer in place."
  (let ((buf (my/typst--pdf-buffer)))
    (when buf
      (with-current-buffer buf
        (when (derived-mode-p 'pdf-view-mode)
          (pdf-view-revert-buffer nil t))))))

(defun my/typst--refresh-preview ()
  "Refresh open preview after save (no watch)."
  (when (my/typst--pdf-buffer)
    (my/typst--compile-async)
    (run-at-time 0.4 nil #'my/typst--refresh-pdf)))

(defun my/typst--compile-async ()
  "Compile current file to PDF in background."
  (when (buffer-file-name)
    (start-process
     "typst-compile" "*typst-compile*"
     typst-executable-location "compile"
     (buffer-file-name) (my/typst--pdf-file))))

(defun my/typst--open-pdf-window ()
  "Open PDF next to source, remember buffer, arm auto-refresh."
  (let* ((pdf (my/typst--pdf-file))
         (buf nil)
         (attempts 0))
        (while (and (not (file-exists-p pdf)) (< attempts 20))
      (sit-for 0.1)
      (setq attempts (1+ attempts)))
    (unless (file-exists-p pdf)
      (user-error "PDF не появился: %s" pdf))
    (setq buf (find-file-noselect pdf))
    (setq my/typst--preview-buffer buf)
        (if (> (window-total-width) 140)
        (display-buffer-in-side-window
         buf
         '((side . right)
           (window-width . 0.45)
           (dedicated . t)))
      (display-buffer
       buf
       '((display-buffer-reuse-window display-buffer-pop-up-window)
         (window-width . 0.5))))
    (with-current-buffer buf
      (pdf-view-mode)
      (pdf-view-fit-page-to-window)
      (display-line-numbers-mode -1)
      (setq-local mode-line-format
                  (list " " mode-line-buffer-identification "  [typst preview] ")))
        (my/typst--stop-notify)
    (setq my/typst--notify-desc
          (ignore-errors
            (file-notify-add-watch pdf t #'my/typst--refresh-pdf)))
        (unless my/typst--notify-desc
      (setq my/typst--fallback-timer
            (run-with-timer 0.5 0.5
                            (lambda ()
                              (when (buffer-live-p my/typst--preview-buffer)
                                (my/typst--refresh-pdf))))))
    buf))

(defun my/typst-live-preview ()
  "Start live preview: typst watch + PDF в соседнем окне."
  (interactive)
  (unless (buffer-file-name)
    (user-error "Буфер не сохранён в файл"))
  (unless (executable-find typst-executable-location)
    (user-error "typst не найден в PATH"))
  (save-buffer)
  (my/typst--stop-watch)
  (let* ((input (file-name-nondirectory (buffer-file-name)))
         (output (concat (file-name-sans-extension input) ".pdf"))
         (default-directory (file-name-directory (buffer-file-name))))
    (setq my/typst--watch-process
          (start-process
           "typst-watch" "*typst-watch*"
           typst-executable-location
           "watch" input output))
    (set-process-sentinel
     my/typst--watch-process
     (lambda (p _e)
       (unless (process-live-p p)
         (message "typst watch остановлен"))))
    (message "typst watch запущен"))
  (my/typst--open-pdf-window))

(defun my/typst-stop-preview ()
  "Stop watch and close preview PDF."
  (interactive)
  (my/typst--stop-watch)
  (my/typst--stop-notify)
  (let ((buf (my/typst--pdf-buffer)))
    (when buf
      (setq my/typst--preview-buffer nil)
      (when-let ((win (get-buffer-window buf)))
        (delete-window win))
      (kill-buffer buf)))
  (message "Typst preview остановлен"))

(defun my/typst-compile ()
  "Compile current file to PDF once."
  (interactive)
  (unless (buffer-file-name)
    (user-error "Буфер не сохранён в файл"))
  (save-buffer)
  (compile compile-command)
  (message "Компиляция запущена…"))

(defun my/typst--bind-keys ()
  "Evil/C-c bindings for typst buffers."
  (when (featurep 'evil)
    (evil-define-key 'normal typst-mode-map
      (kbd "C-c C-c") #'my/typst-compile
      (kbd "C-c C-p") #'my/typst-live-preview
      (kbd "C-c C-s") #'my/typst-stop-preview
      (kbd "C-c C-r") #'my/typst--refresh-pdf)))

(with-eval-after-load 'general
  (with-eval-after-load 'typst-mode
    (my-leader-def :keymaps 'typst-mode-map
      "m c" #'my/typst-compile
      "m p" #'my/typst-live-preview
      "m s" #'my/typst-stop-preview
      "m r" #'my/typst--refresh-pdf)))

(provide 'setup-typst)
