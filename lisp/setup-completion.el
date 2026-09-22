

(use-package vertico
  :init (vertico-mode)
  :bind (:map vertico-map
              ("DEL" . vertico-directory-delete-char) 
              ("C-<backspace>" . vertico-directory-up))) 

(use-package vertico-directory
  :after vertico
  :ensure nil 
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word)))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init (marginalia-mode))

(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)        
  (corfu-auto-delay 0)  
  (corfu-auto-prefix 1))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer))
  :config
    (consult-customize
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-buffer
   :preview-key '(:debounce 0.2 any)) 

  (add-to-list 'consult-buffer-filter "^\\*clang") 
  (add-to-list 'consult-buffer-filter "^\\*EGLOT") 
  (add-to-list 'consult-buffer-filter "^\\*Flycheck") 
  (add-to-list 'consult-buffer-filter "^\\*Epil") 
  (add-to-list 'consult-buffer-filter "^\\*Async") 
  (add-to-list 'consult-buffer-filter "^\\*elpaca") 
  (add-to-list 'consult-buffer-filter "^\\*xref") 
)

(provide 'setup-completion)
