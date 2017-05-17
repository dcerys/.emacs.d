

;(require 'slime-autoloads)
(require 'slime)
;TEMP (slime-setup '(slime-fancy slime-asdf slime-banner))
(global-set-key "\C-cs" 'slime-selector)
(setq slime-complete-symbol*-fancy t)
(setq slime-complete-symbol-function 'slime-fuzzy-complete-symbol)
(global-set-key "\C-c\C-q" 'slime-restart-inferior-lisp)


;; Unfortunately, pcase requires emacs 24 (and LispMachine currently has 23)
;; (pcase (downcase (system-name))
;;   ("nebbiolo" (setq inferior-lisp-program "/usr/local/bin/ccl64"))
;;   ("lispmachine" (setq inferior-lisp-program "/usr/local/acl82/alisp"))
;;   (_ (setq inferior-lisp-program "/usr/local/bin/FIXME")
;;      (error "You need to set the variable inferior-lisp-program in your init file.")))

(let ((name (downcase (substring (system-name) 0 (string-match "\\." (system-name))))))
  (cond ((string= name "nebbiolo")
	 ;(setq inferior-lisp-program "/usr/local/bin/sbcl")
	 (setq inferior-lisp-program "/usr/local/bin/ccl64")
         ;(setq inferior-lisp-program "/Applications/AllegroCL32.app/Contents/Resources/alisp")
	 )
	((string= name "lispmachine")
	 ;(setq inferior-lisp-program "/usr/local/acl82/alisp")
	 ;(setq inferior-lisp-program "/usr/local/acl90/alisp")
         ;(setq inferior-lisp-program "~/mission-lisp")
         (setq slime-lisp-implementations
               '((vanilla ("/usr/local/acl100/alisp"))
                 (mission ("/usr/local/acl100/alisp" "-I" "/home/dcerys/stratus-dev/stratus/code/bin/mission.dxl"))
                 (stratus ("/usr/local/acl100/alisp" "-I" "/home/dcerys/stratus-dev/stratus/code/bin/stratus.dxl"))
                 ))
	 )
	((string= name "pamela")
	 ;(setq inferior-lisp-program "/usr/local/acl100/alisp")
         (setq slime-lisp-implementations
               '((vanilla ("/usr/local/acl100/alisp"))
                 (mission ("/usr/local/acl100/alisp" "-I" "/home/dcerys/stratus-dev/stratus/code/bin/mission.dxl"))
                 (stratus ("/usr/local/acl100/alisp" "-I" "/home/dcerys/stratus-dev/stratus/code/bin/stratus.dxl"))
                 )))
	(t
	 (setq inferior-lisp-program "/usr/local/bin/FIXME")
	 (error "You need to set the variable inferior-lisp-program in your init file."))))

(add-hook 'slime-mode-hook
	   (lambda ()
	     (unless (slime-connected-p)
	       (save-excursion (slime)))))
