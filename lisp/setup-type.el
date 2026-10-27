(use-package monkeytype)

;; слова отсюда - https://github.com/monkeytypegame/monkeytype/tree/master/frontend/static/languages
;; лежат в папке ~/.monkeytype/
setq monkeytype-directory "~/.monkeytype/")

;; (Опционально) Включаем случайный порядок слов, если это необходимо
(setq monkeytype-randomize t)
(provide 'setup-type)
