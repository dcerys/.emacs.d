;; Changes all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)

;; shell scripts
(setq-default sh-basic-offset 2)
(setq-default sh-indentation 2)

;; No need for ~ files when editing
;(setq create-lockfiles nil)

;; Go straight to scratch buffer on startup
(setq inhibit-startup-message t)

;; Override default of xpdf when on a Mac
(when (eq system-type 'darwin)
  (setq rst-pdf-program "open"))

;; Magit
;;(require 'magit)
;;(global-set-key (kbd "C-x M-g") 'magit-dispatch)
;;(define-key magit-file-mode-map
;;  (kbd "C-c g") 'magit-file-popup)
