;;; setup-tg.el --- Evil Russian Layout Fix -*- lexical-binding: t; -*-

;; Проблема: В Evil-mode (Vim) навигация hjkl не работает на русской раскладке.
;; Решение: Пакет reverse-im транслирует нажатия "р/о/л/д" в "h/j/k/l" 
;;          когда ты НЕ в режиме вставки.

(use-package reverse-im
  :ensure t
  :after evil
  :custom
  ;; Указываем, какую раскладку нужно "разворачивать" в латиницу.
  ;; "russian-computer" соответствует стандартной ЙЦУКЕН.
  (reverse-im-input-methods '("russian-computer"))
  :config
  ;; Включаем режим трансляции
  (reverse-im-mode t))

;;; setup-tg.el ends here

(provide 'setup-rus)
