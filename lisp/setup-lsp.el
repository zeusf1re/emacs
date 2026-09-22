;; ~/.config/emacs/lisp/setup-lsp.el

;; LSP Mode
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l") ;; Префикс для LSP команд
  :hook ((c-mode . lsp)
         (c++-mode . lsp)
         (python-mode . lsp))
  :commands lsp
  :config
  (setq lsp-inlay-hint-enable t)

  ;; Включаем семантическую подсветку (попробуем еще раз)
  (setq lsp-semantic-tokens-enable t)
  
  ;; FIX: Если Kanagawa делает серый фон, уберем его принудительно
;; Внутри :config у lsp-mode
(setq lsp-inlay-hint-enable t)
(setq lsp-semantic-tokens-enable t)

;; Исправление фонов (вместо макроса Doom)
(with-eval-after-load 'lsp-semantic-tokens
  ;; Этот код выполнится ТОЛЬКО когда загрузится модуль семантической подсветки
  (set-face-attribute 'lsp-face-semhl-constant nil :background nil)
  (set-face-attribute 'lsp-face-semhl-variable nil :background nil)
  (set-face-attribute 'lsp-face-semhl-function nil :background nil))

)
(with-eval-after-load 'lsp-mode
  (evil-define-key 'normal lsp-mode-map
    (kbd "g d") 'lsp-find-definition
    (kbd "g r") 'lsp-find-references
    (kbd "K")   'lsp-describe-thing-at-point)) ; Аналог Shift+K в Vim (Documentation)

;; 1. Ставим Flycheck
(use-package flycheck
  :init (global-flycheck-mode))

;; 2. Ставим Flycheck-Inline
(use-package flycheck-inline
  :ensure t
  :after flycheck
  :config
  (global-flycheck-inline-mode)
  (setq flycheck-display-errors-delay 0.1)
  )

;; 3. ВАЖНО: Отключаем Sideline в LSP-UI, чтобы они не дрались
(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-sideline-enable nil  ;; <--- ВЫКЛЮЧАЕМ Sideline
        lsp-ui-doc-enable t))











(provide 'setup-lsp)

