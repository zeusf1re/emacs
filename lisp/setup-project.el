;;; setup-project.el --- projectile -*- lexical-binding: t; -*-

(use-package projectile
  :init (projectile-mode +1)
  :config
  (setq projectile-project-search-path '("~/prog/")
        projectile-switch-project-action #'projectile-dired))

(provide 'setup-project)
;;; setup-project.el ends here
