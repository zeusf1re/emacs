;; setup-fasm.el — локальный nasm.el с поддержкой любого регистра

;; Сообщаем Emacs, что есть папка lisp (если ещё не)
; (add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
; 
; ;; Загружаем пакет nasm без попыток установки (:ensure nil)
; (use-package nasm
;   :ensure nil          ; <-- главное: Elpaca не будет пытаться качать
;   :load-path "lisp"    ; искать nasm.el в подпапке lisp
;   :defer t
;   :config
;   ;; Здесь можно оставить любые личные настройки, если понадобится
;   )
; 
; ;; Активируем nasm-mode для файлов .asm
; (add-to-list 'auto-mode-alist '("\\.asm\\'" . nasm-mode))
;  !------------------------- DO NOT DELETE -------------------------!
;; setup-fasm-elpaca.el
;; Убедись, что Elpaca установлен и настроен в твоём init.el

(use-package fasm-mode
  :ensure (:type git :host github :repo "GabrielFrigo4/fasm-mode")
  :defer t
  :config
  ;; Твои настройки для fasm-mode
  )

(add-to-list 'auto-mode-alist '("\\.asm\\'" . fasm-mode))

(provide 'setup-fasm)
