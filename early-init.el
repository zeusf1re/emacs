;;; early-init.el --- Early initialization -*- lexical-binding: t; -*-

;; Runs before init.el and before the first frame.  Kept as a plain file
;; because Org Babel is not available at this stage.

(setq package-enable-at-startup nil)
(setq inhibit-startup-message t)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
(add-to-list 'default-frame-alist '(fullscreen . fullscreen))

(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'none)

;;; early-init.el ends here
