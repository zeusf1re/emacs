(use-package dashboard
  :ensure t
  :config
  (setq dashboard-startup-banner "~/.config/emacs/my_images/Amalthea_dreams.gif")
 (setq dashboard-center-content t)
 (setq dashboard-banner-logo-title nil)

    (setq dashboard-init-info "")

    (setq dashboard-items '((agenda . 5)))

  (setq dashboard-agenda-sort-strategy '((time-up)))

  (setq dashboard-show-shortcuts nil)
(setq dashboard-footer-messages '(""))
(setq dashboard-set-footer nil)          
(setq dashboard-footer-messages nil)     
(setq dashboard-startupify-list (delq 'dashboard-insert-footer dashboard-startupify-list))
 )
(setq initial-buffer-choice
      (lambda ()
        (if (fboundp 'dashboard-open)
            (progn (dashboard-open) (get-buffer "*dashboard*"))
          (get-buffer-create "*scratch*"))))
(provide 'setup-dashboard)
