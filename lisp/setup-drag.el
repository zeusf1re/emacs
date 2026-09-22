(use-package drag-stuff
  :ensure t
  :config
  (drag-stuff-global-mode 1)
  (drag-stuff-define-keys) ;; Включает стандартные бинды M-up/down/left/right
  
  ;; Переопределяем на M-hjkl (для Evil пользователей это кайф)
  :bind (("M-j" . drag-stuff-down)
         ("M-k" . drag-stuff-up)
         ("M-h" . drag-stuff-left)  ;; Двигает слово влево (или регион)
         ("M-l" . drag-stuff-right))) ;; Двигает слово вправо

(provide 'setup-drag)
