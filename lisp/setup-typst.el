(use-package typst-mode
  :ensure (:type git :host github :repo "Ziqi-Yang/typst-mode.el")
  :mode "\\.typ\\'"
  :hook (typst-mode . my/typst--setup)
  :config
  (setq typst-executable-location "typst"))

;; Гарантируем, что .pdf всегда открывается в pdf-view-mode ещё на этапе
;; find-file-noselect, а не через doc-view-mode с последующим переключением.
(with-eval-after-load 'pdf-tools
  (require 'pdf-view)
  (add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode)))

(defun my/typst--setup ()
  "Local setup for `typst-mode'."
  (when (executable-find "tinymist")
    (lsp-deferred))
  ;; Резервный режим, когда watch не запущен. Если watch жив — сами
  ;; ничего не компилируем, чтобы не было гонки.
  (add-hook 'after-save-hook #'my/typst--on-save nil t)
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
(defvar my/typst--refresh-timer nil)

(defun my/typst--pdf-file ()
  (concat (file-name-sans-extension (buffer-file-name)) ".pdf"))

(defun my/typst--watch-alive-p ()
  (and my/typst--watch-process (process-live-p my/typst--watch-process)))

(defun my/typst--stop-watch ()
  (when (my/typst--watch-alive-p)
    (delete-process my/typst--watch-process))
  (setq my/typst--watch-process nil))

(defun my/typst--pdf-buffer ()
  (when (buffer-live-p my/typst--preview-buffer)
    my/typst--preview-buffer))

(defun my/typst--refresh-pdf (&rest _)
  "Revert preview PDF buffer in place, безопасно к гонкам."
  (let ((buf (my/typst--pdf-buffer)))
    (when buf
      (with-current-buffer buf
        (when (and (derived-mode-p 'pdf-view-mode)
                   (file-exists-p (buffer-file-name)))
          (condition-case err
              (pdf-view-revert-buffer nil t)
            (error (message "PDF refresh failed: %s" err))))))))

(defun my/typst--schedule-refresh ()
  "Debounce-перерисовка PDF: watch печатает несколько строк подряд."
  (when my/typst--refresh-timer
    (cancel-timer my/typst--refresh-timer))
  (setq my/typst--refresh-timer
        (run-at-time 0.2 nil #'my/typst--refresh-pdf)))

(defun my/typst--compile-async ()
  "Compile current file to PDF in background (fallback без watch)."
  (when (buffer-file-name)
    (start-process
     "typst-compile" "*typst-compile*"
     typst-executable-location "compile"
     (buffer-file-name) (my/typst--pdf-file))))

(defun my/typst--on-save ()
  "Вызывается при сохранении .typ."
  (when (my/typst--pdf-buffer)
    (if (my/typst--watch-alive-p)
        ;; watch сам перекомпилирует и напечатает в stdout —
        ;; наш process-filter вызовет refresh. Ничего не делаем.
        nil
      (my/typst--compile-async)
      (run-at-time 0.4 nil #'my/typst--refresh-pdf))))

(defun my/typst--open-pdf-window ()
  "Open PDF next to source, remember buffer."
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
          (make-process
           :name "typst-watch"
           :buffer "*typst-watch*"
           :command (list typst-executable-location "watch" input output)
           ;; Ключевой момент: watch печатает в stdout каждый раз,
           ;; когда перекомпилирует. Ловим это и перечитываем PDF.
           :filter (lambda (_proc _output)
                     (my/typst--schedule-refresh))
           :sentinel
           (lambda (p _e)
             (unless (process-live-p p)
               (message "typst watch остановлен")))))
    (message "typst watch запущен"))
  (my/typst--open-pdf-window))

(defun my/typst-stop-preview ()
  "Stop watch and close preview PDF."
  (interactive)
  (my/typst--stop-watch)
  (when my/typst--refresh-timer
    (cancel-timer my/typst--refresh-timer)
    (setq my/typst--refresh-timer nil))
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
