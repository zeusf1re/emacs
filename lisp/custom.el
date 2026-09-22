
(require 'org)

(defun add-songs ()
  "Собрать все строки треков (- ...) из текущего Org-файла
и поместить их единым списком под заголовком * Tracks в конце буфера."
  (interactive)
  (save-excursion
        (goto-char (point-min))
    (when (re-search-forward "^\* Tracks\\(\\s-\\|$\\)" nil t)
      (beginning-of-line)
      (org-mark-subtree)
      (delete-region (region-beginning) (region-end))
      (message "Старая секция Tracks удалена."))
        (let (tracks)
      (goto-char (point-min))
      (while (re-search-forward "^\\([ \t]*\\)- \\(.*\\)" nil t)
        (push (match-string 2) tracks))
      (setq tracks (nreverse tracks))   
            (goto-char (point-max))
            (unless (bolp) (insert "\n"))
      (unless (looking-back "\n\n" nil)
        (insert "\n"))
      (insert "* Tracks\n")
      (dolist (track tracks)
        (insert "- " track "\n"))
      (message "Добавлено %d треков в * Tracks." (length tracks)))))

(provide 'custom)
