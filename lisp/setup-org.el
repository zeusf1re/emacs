(setenv "PATH" (concat "/Library/TeX/texbin:" (getenv "PATH")))
(add-to-list 'exec-path "/Library/TeX/texbin")

(use-package org
    :ensure nil
    :demand t
    :hook (org-mode . org-indent-mode)
    :config
        (setq org-startup-with-inline-images t)   
    (setq org-image-actual-width '(300))      
    (setq org-return-follows-link t)          
    (setq org-hide-emphasis-markers t)        
    (setq org-ellipsis " ▾")

    (setq org-directory "~/org/")
    (setq org-default-notes-file (concat org-directory "/tasks.org"))
    (setq org-capture-templates
            '(("t" "Todo" entry (file+headline "tasks.org" "Inbox")
            "* TODO %?\n  %i\n  %a")
            ("d" "Date Task" entry (file+headline "tasks.org" "Schedule")
            "* TODO %?\n  SCHEDULED: %^t\n")))

      (require 'ox-latex)

    (setq org-latex-compiler "xelatex")

      (setq org-latex-pdf-process
        '("%latex -interaction nonstopmode -output-directory %o %f"
          "%latex -interaction nonstopmode -output-directory %o %f"
          "%latex -interaction nonstopmode -output-directory %o %f"))

    (setq org-latex-default-packages-alist
        '(("" "graphicx" t)
          ("" "longtable" nil)
          ("" "wrapfig" nil)
          ("" "rotating" nil)
          ("normalem" "ulem" t)
          ("" "amsmath" t)
          ("" "amssymb" t)
          ("" "capt-of" nil)
          ("" "hyperref" nil)))

      (setq org-latex-packages-alist
        '(("" "mathtools" t)       
          ("" "geometry" t)        
          ("" "polyglossia" t)))   

      (setq org-preview-latex-default-process 'imagemagick)

    (setq org-preview-latex-process-alist
        '((imagemagick 
           :programs ("xelatex" "convert")
           :description "pdf > png"
           :image-input-type "pdf"
           :image-output-type "png"
           :image-size-adjust (1.0 . 1.0)
           :latex-compiler
                      ("xelatex -interaction nonstopmode -output-directory %o %f")
           :image-converter
                      ("convert -density 320 -trim -antialias %f -quality 100 %O"))))

    (setq org-format-latex-options 
        (plist-put org-format-latex-options :scale 0.5))
  
    (setq org-format-latex-options
        (plist-put org-format-latex-options :background "Transparent"))

    (setq org-confirm-babel-evaluate nil)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t)
     (C . t)
     (js . t)
     (org . t))))
(setq org-babel-python-command "python3")

(defun my/org-latex-preview-all ()
  "Обновить все формулы в буфере"
  (interactive)
  (org-latex-preview '(16)))

(defun my/org-ret-dwim ()
  "Smart RET: follows links, toggles checkboxes, or folds headings.
В нормальном режиме Kakoune (ryo-modal-mode) — dwim-логика,
в режиме вставки — обычный перевод строки."
  (interactive)
  (if (not (bound-and-true-p ryo-modal-mode))
      (org-return)
    (let ((element (org-element-context)))
      (cond
       ((eq major-mode 'sqlite-mode)
        (call-interactively 'sqlite-mode-list-data))
       ((org-at-item-checkbox-p) (org-toggle-checkbox))
       ((eq 'link (org-element-type element)) (org-open-at-point-global))
       ((org-at-heading-p) (org-cycle))
       (t (next-line))))))

;; RET работает в обоих режимах: в normal (ryo-modal-mode) ро-карта не
;; биндит RET, он попадает сюда; в insert проверка внутри функции
;; возвращает org-return. Биндинг «t» → org-todo перенесён в
;; ryo-modal (см. setup-kakoune.el): в org-mode-map он ломал набор
;; буквы «t» в режиме вставки.
(define-key org-mode-map (kbd "RET") #'my/org-ret-dwim)

(use-package org-present
  :ensure t
  :defer t
  :config
    (define-key org-present-mode-keymap (kbd "<left>")  'org-present-prev)
  (define-key org-present-mode-keymap (kbd "<right>") 'org-present-next)
  (define-key org-present-mode-keymap (kbd "<up>")    'org-present-prev)
  (define-key org-present-mode-keymap (kbd "<down>")  'org-present-next)

    (defun my/org-present-fold-subheadings (&rest _)
    "Свернуть все подзаголовки (уровень ≥2) в текущем слайде."
    (save-excursion
      (org-fold-show-all)
      (goto-char (point-min))
      (forward-line 1)
      (while (re-search-forward org-outline-regexp-bol nil t)
        (when (>= (org-outline-level) 2)
          (org-fold-hide-subtree)))))

    (add-hook 'org-present-after-navigate-functions
            #'my/org-present-fold-subheadings)

    (add-hook 'org-present-mode-hook
            (lambda ()
              (org-present-big)
              (org-display-inline-images)
              (org-present-hide-cursor)
              (setq-local face-remapping-alist '((default (:height 1.3) default)))
              (display-line-numbers-mode -1)))

  (add-hook 'org-present-mode-quit-hook
            (lambda ()
              (org-present-small)
              (org-remove-inline-images)
              (org-present-show-cursor)
              (display-line-numbers-mode 1)
              (setq-local face-remapping-alist '()))))

(use-package org-tree-slide
  :ensure t
  :defer t
  :config
  (setq org-tree-slide-skip-outline-level 2)

  (define-key org-tree-slide-mode-map (kbd "<left>")  #'org-tree-slide-move-previous-tree)
  (define-key org-tree-slide-mode-map (kbd "<right>") #'org-tree-slide-move-next-tree)
  (define-key org-tree-slide-mode-map (kbd "<up>")    #'previous-line)
  (define-key org-tree-slide-mode-map (kbd "<down>")  #'next-line)
  (define-key org-tree-slide-mode-map (kbd "n")       #'org-tree-slide-move-next-tree)
  (define-key org-tree-slide-mode-map (kbd "p")       #'org-tree-slide-move-previous-tree)

  (add-hook 'org-tree-slide-play-hook
            (lambda ()
              (setq-local face-remapping-alist '((default (:height 1.5) default)))
              (display-line-numbers-mode -1)))

  (add-hook 'org-tree-slide-stop-hook
            (lambda ()
              (setq-local face-remapping-alist '())
              (display-line-numbers-mode 1))))
(add-hook 'org-mode-hook #'visual-line-mode)



(with-eval-after-load 'org
  (define-key org-read-date-minibuffer-local-map (kbd "h")
    (lambda () (interactive) (org-eval-in-calendar '(calendar-backward-day 1))))
  (define-key org-read-date-minibuffer-local-map (kbd "l")
    (lambda () (interactive) (org-eval-in-calendar '(calendar-forward-day 1))))
  (define-key org-read-date-minibuffer-local-map (kbd "j")
    (lambda () (interactive) (org-eval-in-calendar '(calendar-forward-week 1))))
  (define-key org-read-date-minibuffer-local-map (kbd "k")
    (lambda () (interactive) (org-eval-in-calendar '(calendar-backward-week 1))))
  (define-key org-read-date-minibuffer-local-map (kbd "H")
    (lambda () (interactive) (org-eval-in-calendar '(calendar-backward-month 1))))
  (define-key org-read-date-minibuffer-local-map (kbd "L")
    (lambda () (interactive) (org-eval-in-calendar '(calendar-forward-month 1))))
  (define-key org-read-date-minibuffer-local-map (kbd "K")
    (lambda () (interactive) (org-eval-in-calendar '(calendar-backward-year 1))))
  (define-key org-read-date-minibuffer-local-map (kbd "J")
    (lambda () (interactive) (org-eval-in-calendar '(calendar-forward-year 1))))
  (define-key org-read-date-minibuffer-local-map (kbd "g")
    (lambda () (interactive) (org-eval-in-calendar '(calendar-goto-today)))))

;; ======= org-mode stilisation ======= 
(use-package org-modern
  :ensure t
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :config
  ;; --- Иконки-звёздочки (статичные) ---
  (setq org-modern-star 'replace) ; Включаем режим замены, чтобы ваши символы заработали
(setq org-modern-replace-stars "○○◇◇✳◆□")

  ;; --- Чекбоксы ---
(setq org-modern-checkbox '((88 . "☑") (45 . #("□–" 0 2 (composition (0 2 [9633 8211]))))
 (32 . "□")))

  ;; --- Убираем лишнее в блоках кода ---
  (setq org-modern-table t)          ; Отключаем стилизацию таблиц, если она не нужна
  (setq org-modern-block-fringe nil)   ; Убираем полоску слева от блоков

  (with-eval-after-load 'org
    (custom-set-faces
     ;; Заголовки
     '(org-level-1 ((t (:foreground "#B8B4D0" :height 1.25 :weight bold))));;8992A7
     '(org-level-2 ((t (:foreground "#8ba4b0" :height 1.2 :weight semi-bold))));; c4b28a
     '(org-level-3 ((t (:foreground "#a292a3" :height 1.1 :weight normal))))

     ;; Verbatim и Code
     '(org-verbatim ((t (:foreground "#b6927b" :background nil))))

     ;; Статус DONE
     '(org-done ((t (:foreground "#98BB6C" :strike-through nil :weight semi-bold)))))))

(with-eval-after-load 'org-modern
  (custom-set-faces
   ;; Базовая метка: высота как у основного текста (или чуть меньше), жирный шрифт
   '(org-modern-label ((t (:height 0.9 :weight semi-bold :inherit default))))

   ;; DONE — спокойный зелёный Kanagawa
   '(org-modern-done ((t (:background "#98BB6C" :foreground "#1f1f28" :weight bold))))
   '(org-modern-todo ((t (:background "#DCA561" :foreground "#1f1f28" :weight bold))))

   ;; Приоритеты
   '(org-modern-priority ((t (:background "#a292a3" :foreground "#1f1f28"))))

   ;; Теги
   '(org-modern-tag ((t (:background "#2d4f67" :foreground "#dcd7ba"))))
   )
  )
;; org-agenda-structure

;; И не забываем про сам текст заголовка со статусом DONE
(with-eval-after-load 'org
  (custom-set-faces
   '(org-done ((t (:foreground "#8a9a7b" :strike-through nil :weight normal))))
   '(org-headline-done ((t (:strike-through nil :foreground "#8a9a7b"))))
   )
  (setq org-fontify-done-headline nil)
  )

;; ================= plans.org autosort ================
;; ====== Автоматический перенос DONE задач в секцию "Уже сделано" ======
;; ====== Автоматический перенос DONE задач в секцию "Уже сделано" ======
(defun my/org-move-done-to-bottom ()
  "Move a task to the end of the '* Уже сделано :done:' section when marked DONE."
  (when (equal org-state "DONE")
    (let ((task-marker (point-marker)))
      (run-at-time 0.1 nil
                   (lambda (marker)
                     (when (marker-buffer marker)
                       (with-current-buffer (marker-buffer marker)
                         (save-excursion
                           (goto-char marker)
                           (when (org-at-heading-p)
                             (org-back-to-heading t)
                             ;; Проверяем, не в этой ли секции мы уже находимся
                             (let ((parent-heading
                                    (save-excursion
                                      (ignore-errors
                                        (org-up-heading-safe)
                                        (org-get-heading t t t t)))))
                               (unless (and parent-heading 
                                            (string-match-p "Уже сделано" parent-heading))
                                 
                                 ;; Ищем секцию по тегу :done: или по названию
                                 (let ((target-marker
                                        (save-excursion
                                          (goto-char (point-min))
                                          (when (or (re-search-forward "^\\*+ .*:done:" nil t)
                                                    (re-search-forward "^\\*+ Уже сделано" nil t))
                                            ;; Так как секция всегда в конце, прыгаем в конец буфера
                                            (goto-char (point-max))
                                            (copy-marker (point))))))
                                   
                                   (if (marker-position target-marker)
                                       (progn
                                         ;; 1. Вырезаем задачу
                                         (org-cut-subtree)
                                         ;; 2. Идем в конец файла и вставляем как уровень 2 (**)
                                         (goto-char target-marker)
                                         (unless (bolp) (newline))
                                         (org-paste-subtree 2)
                                         (set-marker target-marker nil)
                                         
                                         ;; 3. Сворачиваем секцию "Уже сделано"
                                         (save-excursion
                                           (goto-char (point-min))
                                           (when (or (re-search-forward "^\\*+ .*:done:" nil t)
                                                     (re-search-forward "^\\*+ Уже сделано" nil t))
                                             (org-back-to-heading t)
                                             (org-fold-hide-subtree)))
                                             
                                         (message "Task moved to 'Уже сделано' and section folded."))
                                     (message "Warning: Section with tag ':done:' or name 'Уже сделано' not found.")))))))))
                     (set-marker marker nil))
                   task-marker))))
(add-hook 'org-after-todo-state-change-hook #'my/org-move-done-to-bottom)
;; ================= plans.org autosort ================

(provide 'setup-org)

