(use-package dired-ranger
  :ensure t
  :defer t)

(defun my/dired-evil-bindings ()
  "Мои кастомные биндинги для dired в evil-mode."
  (interactive)
  (evil-define-key 'normal dired-mode-map
    ;; Навигация
    "h" 'dired-up-directory
    "l" 'dired-find-file
    ;; "j" и "k" уже работают по умолчанию в evil

    ;; Создание файлов и директорий
    "a" 'dired-create-empty-file
    "A" 'dired-create-directory

    ;; Dired-ranger: копирование / перемещение / вставка
    "c" 'dired-ranger-copy
    "M" 'dired-ranger-move
    "p" 'dired-ranger-paste

    ;; Удаление (стандартный dired, помечает файлы на удаление)
    "d" 'dired-do-delete

    ;; Вход в режим редактирования имён (wdired)
    "i" 'wdired-change-to-wdired-mode)

  ;; Маркировка: m работает и в normal, и в visual
  (evil-define-key 'normal dired-mode-map
    "m" 'dired-mark)
  (evil-define-key 'visual dired-mode-map
    "m" 'dired-mark))

(add-hook 'dired-mode-hook #'my/dired-evil-bindings)

(dirvish-override-dired-mode -1)
(when (bound-and-true-p dirvish-mode)
  (dirvish-mode -1))

(provide 'setup-dired)
