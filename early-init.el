
;; ~/.config/emacs/early-init.el

;; Отключаем UI элементы до того, как они отрисуются
(setq package-enable-at-startup nil)
(setq inhibit-startup-message t)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
;; Сразу на весь экран (как ты хотел)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq mac-command-modifier 'meta)   ; Cmd -> Meta
(setq mac-option-modifier 'none)    ; Option -> как в системе (для ввода символов)
;; ИЛИ
;; (setq mac-option-modifier 'super) ; Option -> Super
