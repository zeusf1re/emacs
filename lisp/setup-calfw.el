(use-package calfw
  :ensure t
  :config
  (require 'calfw-org))

(with-eval-after-load 'calfw
  (define-key calfw-calendar-mode-map (kbd "j")  #'calfw-navi-next-week-command)
  (define-key calfw-calendar-mode-map (kbd "k")  #'calfw-navi-previous-week-command)
  (define-key calfw-calendar-mode-map (kbd "h")  #'calfw-navi-previous-day-command)
  (define-key calfw-calendar-mode-map (kbd "l")  #'calfw-navi-next-day-command)
  (define-key calfw-calendar-mode-map (kbd "g")  #'calfw-org-goto-date)
  (define-key calfw-calendar-mode-map (kbd "x")  #'calfw-refresh-calendar-buffer)
  (define-key calfw-calendar-mode-map (kbd "q")  #'bury-buffer)
  (define-key calfw-calendar-mode-map (kbd "RET") #'calfw-org-open-agenda-day)
  (define-key calfw-calendar-mode-map (kbd "TAB") #'calfw-show-details-command))

(autoload 'calfw-open-org-calendar "calfw-org" "Open Org Calendar" t)

(use-package calfw-org
  :ensure t)

(provide 'setup-calfw)
