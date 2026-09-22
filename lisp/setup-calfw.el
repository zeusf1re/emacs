(use-package calfw
  :ensure t
  :config
  (require 'calfw-org)
  ;;  (setq calfw-org-agenda-schedule-args '(:timestamp :sexp :scheduled :deadline))
  


  ;; Используем хук: этот код выполнится каждый раз, когда создается календарь
;;  (add-hook 'calfw-calendar-mode-hook
;;            (lambda ()
;;              ;; Здесь карта клавиш (cfw:calendar-mode-map) ТОЧНО существует,
;;              ;; так как мы находимся внутри режима календаря.
;;              ;; Используем local-set-key, чтобы менять клавиши только в этом буфере.
;;              (local-set-key "j" 'calfw-navi-next-week-command)
;;              (local-set-key "k" 'calfw-navi-previous-week-command)
;;              (local-set-key "h" 'calfw-navi-previous-day-command)
;;              (local-set-key "l" 'calfw-navi-next-day-command)
;;              (local-set-key "g" 'calfw-org-goto-date)
;;              (local-set-key "x" 'calfw-refresh-calendar-buffer)
;;              (local-set-key "q" 'bury-buffer)
;;              (local-set-key (kbd "RET") 'calfw-org-open-agenda-day)
  ;;              (local-set-key (kbd "TAB") 'calfw-show-details-command)))
 )
(with-eval-after-load 'calfw
  (evil-define-key '(normal motion) calfw-calendar-mode-map
    "j" 'calfw-navi-next-week-command
    "k" 'calfw-navi-previous-week-command
    "h" 'calfw-navi-previous-day-command
    "l" 'calfw-navi-next-day-command
    "g" 'calfw-org-goto-date
    "x" 'calfw-refresh-calendar-buffer
    "q" 'bury-buffer
    (
     kbd "RET") 'calfw-org-open-agenda-day
    (kbd "TAB") 'calfw-show-details-command))


;; SPC o c (если ты настроил general в init.el)
;; (Если general определен в другом месте, убедись, что он видит эту команду)
;; Если general здесь недоступен, просто добавь autoload или require, 
;; но лучше биндинг "SPC ..." оставить в init.el или setup-evil.el
(autoload 'calfw-open-org-calendar "calfw-org" "Open Org Calendar" t)

(provide 'setup-calfw)
;; Биндинг для запуска календаря
(use-package calfw-org
  :ensure t)

(provide 'setup-calfw) ;; Если вынес в отдельный
