(use-package drag-stuff
  :ensure t
  :config
  (drag-stuff-global-mode 1)
  (drag-stuff-define-keys) 
  
    :bind (("M-j" . drag-stuff-down)
         ("M-k" . drag-stuff-up)
         ("M-h" . drag-stuff-left)  
         ("M-l" . drag-stuff-right))) 

(provide 'setup-drag)
