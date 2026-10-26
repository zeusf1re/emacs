;; org-roam
;;; ---- Org-roam ----
(use-package org-roam
  :ensure t
  :after org
  :custom
  (org-roam-directory (file-truename "~/org/roam/"))
  ;; 2. Папка для ежедневника (Dailies)
  (org-roam-dailies-directory "daily/")
  ;; 3. База данных для мгновенного поиска (SQLite)
  (org-roam-database-connector 'sqlite-builtin)
  :config
  (add-to-list 'org-roam-buffer-postrender-functions
             #'magit-section-show-level-2-all) 
  (setq org-roam-node-display-template
        (concat "${title:*} " (propertize "${tags:15}" 'face 'org-tag)))
  ;; Шаблон для новой заметки-узла
(defvar my/org-roam-lecture-header
  (concat
   "#+TITLE: ${title}\n"
   "#+AUTHOR: Студент группы ИУ5-56Б Канаев А.И.\n"
   "#+DATE: %<%Y-%m-%d>\n"
   "#+LANGUAGE: ru\n"
   "#+OPTIONS: toc:1 num:t ^:nil\n"
   "#+STARTUP: fold\n"
   "#+LATEX_COMPILER: xelatex\n"
   "#+LATEX_HEADER: \\setmainfont{Arial}\n"
   "#+LATEX_HEADER: \\setsansfont{Arial}\n"
   "#+LATEX_HEADER: \\setmonofont{Menlo}\n"
   "#+LATEX_HEADER: \\newfontfamily\\cyrillicfont{Arial}\n"
   "#+LATEX_HEADER: \\newfontfamily\\cyrillicfontsf{Arial}\n"
   "#+LATEX_HEADER: \\newfontfamily\\cyrillicfonttt{Menlo}\n"
   "#+LATEX_HEADER: \\geometry{left=1cm, right=1cm, top=2cm, bottom=2cm}\n"
   "#+LATEX_HEADER: \\usepackage{minted}\n"
   "#+LATEX_HEADER: \\usepackage{xcolor}\n"
   "#+LATEX_HEADER: \\definecolor{bg}{HTML}{282828}\n")
  "Header for lecture notes in org-roam.")

(setq org-roam-capture-templates
      `(("d" "default" plain "%?"
         :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+TITLE: ${title}\n")
         :unnarrowed t)
        ("l" "lecture" plain "%?"
         :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            ,my/org-roam-lecture-header)
         :unnarrowed t)

("v" "discipline" plain "%?"
 :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                     ":PROPERTIES:\n:CATEGORY: ${title}\n:END:\n#+TITLE: ${title}\n#+filetags: :discipline:\n")
 :unnarrowed t)
        ))
  ;; Шаблон для ежедневной заметки
  (setq org-roam-dailies-capture-templates
        '(("d" "default" entry "* %?"
           :target (file+head "%<%Y-%m-%d>.org"
                              "#+title: %<%Y-%m-%d>\n"))))
  ;; Активируем режим
  (org-roam-setup))


(with-eval-after-load 'org-roam
  (with-eval-after-load 'evil
    (evil-set-initial-state 'org-roam-buffer-mode 'normal)))
(with-eval-after-load 'org-roam
  (with-eval-after-load 'evil
    (evil-define-key 'normal org-roam-preview-map
      (kbd "0") #'evil-beginning-of-line
      (kbd "^") #'evil-first-non-blank
      (kbd "$") #'evil-end-of-line)))

;; === org-download ==
(use-package org-download
  :ensure t
  :after org
  :config
  ;; 1. Изображения будут складываться в ~/org/roam/images/
  (setq org-download-method 'directory)
  (setq org-download-image-dir (expand-file-name "images" org-roam-directory))
  ;; 2. Отключаем создание подпапок по заголовкам, чтобы всё было в одной папке
  (setq org-download-heading-lvl nil)
  ;; 3. Добавляем временную метку к имени файла, чтобы имена были уникальными
  (setq org-download-timestamp "%Y%m%d-%H%M%S_")
  ;; 4. Для macOS: указываем, какую утилиту использовать для работы с буфером
  (setq org-download-screenshot-method "/opt/homebrew/bin/pngpaste %s")
  :bind (("C-M-y" . org-download-clipboard) ; Удобный биндинг для вставки
         ("C-c i i" . org-download-image))) ; Для вставки из файла
(setq org-download-annotate-function (lambda (_link) ""))
;;(setq org-roam-graph-exclude-matcher '("daily" "journal" "2026-")) -- чтобы вырубить дневники из графа

;; === graph ui ===
(use-package org-roam-ui
  :ensure t
  :after org-roam
  :config
  ;; Синхронизировать тему ORUI с темой Emacs
  (setq org-roam-ui-sync-theme t)
  ;; Следовать за текущим узлом в Emacs
  (setq org-roam-ui-follow t)
  ;; Обновлять граф при сохранении файла
  (setq org-roam-ui-update-on-save t)
  ;; Не открывать браузер автоматически при запуске
  (setq org-roam-ui-open-on-start nil))
;;       ======= system crafters funcs =======
(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (push arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

(defun my/org-roam-refresh-agenda-list ()
  "Обновить `org-agenda-files` файлами с тегом 'discipline'."
  (interactive)
  (let ((project-files
         (mapcar #'org-roam-node-file
                 (seq-filter
                  (lambda (node)
                    (member "discipline" (org-roam-node-tags node)))
                  (org-roam-node-list)))))
    (setq org-agenda-files (append project-files
                                   (list (expand-file-name "~/org/roam/daily/")) ;; Твои дейли-заметки
                                   (list (expand-file-name "~/org/tasks.org")))))) ;; Твой файл входящих задач
;; Обновлять список при запуске org-agenda
(add-hook 'org-agenda-mode-hook #'my/org-roam-refresh-agenda-list)

;; Или обновлять при сохранении любого org-roam файла
(add-hook 'org-roam-capture-new-node-hook #'my/org-roam-refresh-agenda-list)
(defun my/org-roam-node-find-by-tag ()
  "Запросить тег и найти узел org-roam только с этим тегом."
  (interactive)
  (let ((tag (completing-read "Tag: " (org-roam-tag-completions) nil t)))
    (org-roam-node-find nil nil
                        (lambda (node)
                          (member tag (org-roam-node-tags node))))))
(provide 'setup-roam)
