(require 'ox-latex)

;; 1. Указываем, что хотим использовать minted
(setq org-latex-src-block-backend 'minted)

;; 2. Добавляем пакет minted в список загружаемых LaTeX-пакетов
(add-to-list 'org-latex-packages-alist '("newfloat" "minted"))

;; 3. ВАЖНО: Добавляем -shell-escape в команду сборки PDF
;;    Это разрешает LaTeX вызывать внешние программы, такие как Pygments.
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
