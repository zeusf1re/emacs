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
(use-package org-modern
  :ensure t
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :config
  (setq org-modern-star '("◉" "○" "◈" "◇" "✳" "◆" "□"))
  (setq org-modern-table nil)) 

(defun my/org-latex-preview-all ()
  "Обновить все формулы в буфере"
  (interactive)
  (org-latex-preview '(16)))

(defun my/org-ret-dwim ()
  "Smart RET: follows links, toggles checkboxes, or folds headings."
  (interactive)
  (let ((element (org-element-context)))
    (cond
     ((eq major-mode 'sqlite-mode)
      (call-interactively 'sqlite-mode-list-data))
     ((org-at-item-checkbox-p) (org-toggle-checkbox))
     ((eq 'link (org-element-type element)) (org-open-at-point-global))
     ((org-at-heading-p) (org-cycle))
     (t (evil-next-line)))))

(with-eval-after-load 'evil
  (with-eval-after-load 'org
    (evil-define-key 'normal org-mode-map (kbd "RET") 'my/org-ret-dwim)
    (evil-define-key 'insert org-mode-map (kbd "RET") 'org-return)))

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
              (display-line-numbers-mode -1)
              (when (featurep 'evil)
                (evil-local-set-key 'normal (kbd "<left>")  'org-present-prev)
                (evil-local-set-key 'normal (kbd "<right>") 'org-present-next)
                (evil-local-set-key 'normal (kbd "<up>")    'org-present-prev)
                (evil-local-set-key 'normal (kbd "<down>")  'org-present-next))))

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

      (define-key org-tree-slide-mode-map (kbd "<up>") nil)
  (define-key org-tree-slide-mode-map (kbd "<down>") nil)

      (define-key org-tree-slide-mode-map (kbd "n") 'org-tree-slide-move-next-tree)
  (define-key org-tree-slide-mode-map (kbd "p") 'org-tree-slide-move-previous-tree)

    (add-hook 'org-tree-slide-play-hook
            (lambda ()
                            (setq-local face-remapping-alist '((default (:height 1.5) default)))
              (display-line-numbers-mode -1)
                                                        (when (featurep 'evil)
                (evil-local-set-key 'normal (kbd "<left>")  'org-tree-slide-move-previous-tree)
                (evil-local-set-key 'normal (kbd "<right>") 'org-tree-slide-move-next-tree)
                (evil-local-set-key 'normal (kbd "<up>")    'previous-line)
                (evil-local-set-key 'normal (kbd "<down>")  'next-line))))

  (add-hook 'org-tree-slide-stop-hook
            (lambda ()
              (setq-local face-remapping-alist '())
              (display-line-numbers-mode 1))))

(provide 'setup-org)
