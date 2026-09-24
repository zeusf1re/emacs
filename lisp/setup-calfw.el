(use-package calfw
  :ensure t
  :config
  (require 'calfw-org))

(with-eval-after-load 'calfw
  (evil-define-key '(normal motion) calfw-calendar-mode-map
    "j" 'calfw-navi-next-week-command
    "k" 'calfw-navi-previous-week-command
    "h" 'calfw-navi-previous-day-command
    "l" 'calfw-navi-next-day-command
    "g" 'calfw-org-goto-date
    "x" 'calfw-refresh-calendar-buffer
    "q" 'bury-buffer
    (kbd "RET") 'calfw-org-open-agenda-day
    (kbd "TAB") 'calfw-show-details-command))

(autoload 'calfw-open-org-calendar "calfw-org" "Open Org Calendar" t)

(use-package calfw-org
  :ensure t)

(provide 'setup-calfw)
