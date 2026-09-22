(setq telega-server-libs-prefix "/opt/homebrew")

(setenv "PKG_CONFIG_PATH" 
        (concat "/opt/homebrew/lib/pkgconfig:" (getenv "PKG_CONFIG_PATH")))

(use-package telega
  :ensure (:host github :repo "zevlg/telega.el")
  :defer t 
  :commands (telega)
  :config
    (with-eval-after-load 'evil
    (evil-set-initial-state 'telega-root-mode 'emacs)
    (evil-set-initial-state 'telega-chat-mode 'emacs))
  
    (setq telega-use-images t)
  
    (telega-mode-line-mode 1)
  
    (setq telega-notifications-mode t))

(provide 'setup-tg)
