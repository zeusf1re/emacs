;;; === НАСТРОЙКА ОКРУЖЕНИЯ ===
;; Добавляем пути к TeX (важно для macOS)
(setenv "PATH" (concat "/Library/TeX/texbin:" (getenv "PATH")))
(add-to-list 'exec-path "/Library/TeX/texbin")

;;; === ORG MODE CONFIG ===
(use-package org
  :ensure nil
  :demand t
  :hook (org-mode . org-indent-mode)
  :config
  ;; --- 1. Внешний вид и поведение ---
  (setq org-startup-with-inline-images t)   ; Картинки сразу
  (setq org-image-actual-width '(300))      ; Ширина картинок по умолчанию
  (setq org-return-follows-link t)          ; Enter переходит по ссылкам
  (setq org-hide-emphasis-markers t)        ; Скрывать /курсив/ и *жирный*
  (setq org-ellipsis " ▾")

  ;; --- 2. Пути и Capture ---
  (setq org-directory "~/org/")
  (setq org-default-notes-file (concat org-directory "/tasks.org"))
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "tasks.org" "Inbox")
           "* TODO %?\n  %i\n  %a")
          ("d" "Date Task" entry (file+headline "tasks.org" "Schedule")
           "* TODO %?\n  SCHEDULED: %^t\n")))

  ;; --- 3. ЭКСПОРТ В PDF (Файл) ---
  ;; Загружаем модуль экспорта
  (require 'ox-latex)

  ;; Используем XeLaTeX (для поддержки UTF-8 и шрифтов системы)
  (setq org-latex-compiler "xelatex")

  ;; Команда сборки PDF. %latex заменится на xelatex.
  ;; Запускаем 3 раза для корректных ссылок и номеров страниц.
  (setq org-latex-pdf-process
        '("%latex -interaction nonstopmode -output-directory %o %f"
          "%latex -interaction nonstopmode -output-directory %o %f"
          "%latex -interaction nonstopmode -output-directory %o %f"))

  ;; Чистим дефолтные пакеты (убираем inputenc/fontenc, они не нужны XeTeX)
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

  ;; Настраиваем пакеты: Polyglossia (Русский язык) + Mathtools (Формулы)
  ;; Важно: mathtools загружаем раньше polyglossia
  (setq org-latex-packages-alist
        '(("" "mathtools" t)       ; Исправляет cases, matrices
          ("" "geometry" t)        ; Поля страницы
          ("" "polyglossia" t)))   ; Язык (вместо babel)

  ;; --- 4. PREVIEW В БУФЕРЕ (Картинки формул) ---
  ;; Используем ImageMagick (PNG), так как он самый надежный для сложных формул
  (setq org-preview-latex-default-process 'imagemagick)

  ;; Настройка процесса генерации PNG
  (setq org-preview-latex-process-alist
        '((imagemagick 
           :programs ("xelatex" "convert")
           :description "pdf > png"
           :image-input-type "pdf"
           :image-output-type "png"
           :image-size-adjust (1.0 . 1.0)
           :latex-compiler
           ;; Генерируем PDF (самый точный формат)
           ("xelatex -interaction nonstopmode -output-directory %o %f")
           :image-converter
           ;; Конвертируем PDF в PNG с высоким DPI (400) для четкости на Retina
           ("convert -density 320 -trim -antialias %f -quality 100 %O"))))

  ;; Увеличиваем масштаб формул в редакторе (чтобы не было мелко)
  (setq org-format-latex-options 
        (plist-put org-format-latex-options :scale 0.5))
  
  ;; Прозрачный фон для темной темы
  (setq org-format-latex-options
        (plist-put org-format-latex-options :background "Transparent"))

  ;; --- 5. BABEL (выполнение SRC-блоков) ---
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
;;; === ВНЕШНИЙ ВИД (Org Modern) ===
(use-package org-modern
  :ensure t
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :config
  (setq org-modern-star '("◉" "○" "◈" "◇" "✳" "◆" "□"))
  (setq org-modern-table nil)) ; Отключаем, если таблицы тормозят или ломаются

;;; === EVIL MODE TWEAKS ===
(with-eval-after-load 'evil
  (with-eval-after-load 'org
    ;; Enter открывает ссылки / сворачивает заголовки
    (evil-define-key 'normal org-mode-map (kbd "RET") 'org-open-at-point)
    (evil-define-key 'insert org-mode-map (kbd "RET") 'org-return)))

;;; === ПОЛЕЗНЫЕ ФУНКЦИИ ===
(defun my/org-latex-preview-all ()
  "Обновить все формулы в буфере"
  (interactive)
  (org-latex-preview '(16)))
(with-eval-after-load 'evil
  (with-eval-after-load 'org
    ;; Принудительно ставим в evil-normal-state-map (самый высокий приоритет)
    (define-key evil-normal-state-map (kbd "RET") 'my/org-ret-dwim)))

;; Саму функцию (если вдруг она потерялась или не загрузилась)
(defun my/org-ret-dwim ()
  "Smart RET: follows links, toggles checkboxes, or folds headings."
  (interactive)
  (let ((element (org-element-context)))
    (cond
     ((org-at-item-checkbox-p) (org-toggle-checkbox))
     ((eq 'link (org-element-type element)) (org-open-at-point-global))
     ((org-at-heading-p) (org-cycle))
     (t (evil-next-line)))))
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
  ;; Клавиши стрелок
  (define-key org-present-mode-keymap (kbd "<left>")  'org-present-prev)
  (define-key org-present-mode-keymap (kbd "<right>") 'org-present-next)
  (define-key org-present-mode-keymap (kbd "<up>")    'org-present-prev)
  (define-key org-present-mode-keymap (kbd "<down>")  'org-present-next)

  ;; Функция сворачивания (с совместимостью с хуком)
  (defun my/org-present-fold-subheadings (&rest _)
    "Свернуть все подзаголовки (уровень ≥2) в текущем слайде."
    (save-excursion
      (org-fold-show-all)
      (goto-char (point-min))
      (forward-line 1)
      (while (re-search-forward org-outline-regexp-bol nil t)
        (when (>= (org-outline-level) 2)
          (org-fold-hide-subtree)))))

  ;; Вешаем на хук навигации
  (add-hook 'org-present-after-navigate-functions
            #'my/org-present-fold-subheadings)

  ;; Визуальные настройки при входе/выходе
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
  ;; Ограничиваем видимость: показывать только до 2-го уровня (H1 и H2),
  ;; более глубокие заголовки и их содержимое будут скрыты.
  (setq org-tree-slide-skip-outline-level 2)

  ;; Убираем из слайд-режима стандартные привязки ↑/↓,
  ;; чтобы они работали как обычное перемещение курсора.
  (define-key org-tree-slide-mode-map (kbd "<up>") nil)
  (define-key org-tree-slide-mode-map (kbd "<down>") nil)

  ;; Оставляем ←/→ для переключения слайдов (они там уже привязаны)
  ;; При желании добавляем n/p как альтернативу:
  (define-key org-tree-slide-mode-map (kbd "n") 'org-tree-slide-move-next-tree)
  (define-key org-tree-slide-mode-map (kbd "p") 'org-tree-slide-move-previous-tree)

  ;; Настройка внешнего вида (аналогично org-present):
  (add-hook 'org-tree-slide-play-hook
            (lambda ()
              ;; Увеличиваем шрифт, но вы просили поменьше — подберите высоту
              (setq-local face-remapping-alist '((default (:height 1.5) default)))
              (display-line-numbers-mode -1)
              ;; Скрываем курсор, если мешает (по желанию)
              ;; (org-tree-slide--hide-cursor)
              ;; Для Evil: разрешаем стрелки во всех состояниях
              (when (featurep 'evil)
                (evil-local-set-key 'normal (kbd "<left>")  'org-tree-slide-move-previous-tree)
                (evil-local-set-key 'normal (kbd "<right>") 'org-tree-slide-move-next-tree)
                (evil-local-set-key 'normal (kbd "<up>")    'previous-line)
                (evil-local-set-key 'normal (kbd "<down>")  'next-line))))

  (add-hook 'org-tree-slide-stop-hook
            (lambda ()
              (setq-local face-remapping-alist '())
              (display-line-numbers-mode 1)
              ;; курсор сам вернётся, если не прятали
              ))
  )

(provide 'setup-org)
