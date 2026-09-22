(require 'ox-latex)

(setq org-latex-src-block-backend 'minted)

(add-to-list 'org-latex-packages-alist '("newfloat" "minted"))

(setq org-latex-pdf-process
      '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
(setq org-latex-minted-options
      '(("style" "gruvbox-dark")
        ("bgcolor" "bg")       
        ("frame" "lines")       
        ("linenos")))            

(provide 'setup-latex)
