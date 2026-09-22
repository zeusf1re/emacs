;; 1. Указываем путь к корню библиотек Homebrew
(setq telega-server-libs-prefix "/opt/homebrew")

;; 2. (На всякий случай) Обновляем переменные окружения, чтобы компилятор видел хедеры
(setenv "PKG_CONFIG_PATH" 
        (concat "/opt/homebrew/lib/pkgconfig:" (getenv "PKG_CONFIG_PATH")))

(use-package telega
  :ensure (:host github :repo "zevlg/telega.el")
  :defer t ;; Не загружать при старте Emacs (для ускорения)
  :commands (telega)
  :config
  ;; Если ты используешь evil, настроим клавиши
  (with-eval-after-load 'evil
    (evil-set-initial-state 'telega-root-mode 'emacs)
    (evil-set-initial-state 'telega-chat-mode 'emacs))
  
  ;; Сделать так, чтобы картинки и видео показывались
  (setq telega-use-images t)
  
  ;; (Опционально) Иконка в mode-line
  (telega-mode-line-mode 1)
  
  ;; (Опционально) Уведомления через систему
  (setq telega-notifications-mode t))

(provide 'setup-tg)
