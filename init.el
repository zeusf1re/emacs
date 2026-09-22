;; ~/.config/emacs/init.el

;; Убираем мусорные файлы в отдельную папку
(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))
(setq auto-save-list-file-prefix (expand-file-name "tmp/auto-saves/sessions/" user-emacs-directory))
(setq auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/auto-saves/" user-emacs-directory) t)))

;; Отключаем lockfiles (файлы вида .#main.c, которые мешают npm/webpack/git)
(setq create-lockfiles nil)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; 1. Установка Elpaca (Package Manager)
(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                 ((zerop (call-process "git" nil buffer t "clone"
                                       (plist-get order :repo) repo)))
                 ((zerop (call-process "git" nil buffer t "checkout"
                                       (or (plist-get order :ref) "--"))))
                 (emacs (concat invocation-directory invocation-name))
                 ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "-batch"
                                       "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                 ((require 'elpaca))
                 ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (funcall #'elpaca--format-error err)))
      ((error) (warn "%s" err) (delete-directory elpaca-directory 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; 2. Поддержка use-package (чтобы писать конфиг как в Doom/Lazy)
(elpaca elpaca-use-package
  (elpaca-use-package-mode)
  (setq elpaca-use-package-by-default t))

;; 3. Базовые настройки (табы, номера строк)
(setq-default
 tab-width 4
 indent-tabs-mode nil ;; Использовать пробелы
 display-line-numbers-type 'relative) ;; Относительные номера строк

(global-display-line-numbers-mode t)
(column-number-mode)

;; Добавляем папку lisp в путь, чтобы Emacs видел твои модули
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(setq-default truncate-lines t)

(setq ring-bell-function 'ignore) ; Выключить звук полностью
;; 4. ЗАГРУЗКА МОДУЛЕЙ (Сюда будем добавлять файлы)
(require 'custom)
(require 'setup-evil)
(require 'setup-ui)
(require 'setup-completion)
(require 'setup-lsp)
(require 'setup-help)
(require 'setup-project)
(require 'setup-term)
(require 'setup-pdf)
(require 'setup-org)
(require 'setup-drag)
(require 'setup-agenda)
(require 'setup-calfw)
(require 'setup-tg)
(require 'setup-rus)
(require 'setup-fasm)
(require 'setup-latex)
(require 'setup-dashboard)
(require 'setup-typst)
