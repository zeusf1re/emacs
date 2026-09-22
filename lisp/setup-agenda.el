(setq org-agenda-files (directory-files-recursively "~/org" "\\.org$"))

(setq org-agenda-start-on-weekday nil)  
(setq org-agenda-start-day "+0d")       
(setq org-agenda-span 7)                

(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys)

    (evil-define-key 'motion org-agenda-mode-map
    (kbd "t") 'org-agenda-todo          
    (kbd "I") 'org-agenda-clock-in      
    (kbd "O") 'org-agenda-clock-out     
    (kbd "s") 'org-agenda-schedule      
    (kbd "d") 'org-agenda-deadline      
    (kbd "c") 'org-capture              
    (kbd "q") 'org-agenda-quit          
    (kbd "r") 'org-agenda-redo          
    (kbd "g") 'org-agenda-redo-all)     

    (evil-define-key 'normal org-agenda-mode-map
    (kbd "t") 'org-agenda-todo
    (kbd "I") 'org-agenda-clock-in
    (kbd "O") 'org-agenda-clock-out
    (kbd "s") 'org-agenda-schedule
    (kbd "d") 'org-agenda-deadline
    (kbd "c") 'org-capture
    (kbd "q") 'org-agenda-quit
    (kbd "r") 'org-agenda-redo
    (kbd "g") 'org-agenda-redo-all))
(provide 'setup-agenda)
