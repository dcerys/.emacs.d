
;; Setup slime and lisp
(defvar lisp-mode-to-use (if (eq system-type 'darwin)
                             'slime
                           'allegro)
  "What lisp mode to use.  The supported values are:
allegro, slime, nil.")

(setq allegro-directory "/usr/local/acl100/")

(cond ((eq lisp-mode-to-use 'slime)
       (load "setup-slime.el")
       )
      ((eq lisp-mode-to-use 'allegro)
       (load "setup-allegro.el"))
      ((null lisp-mode-to-use) nil)
      (t (error (format "Unexpected value for lisp-mode-to-use %S"
                        lisp-mode-to-use))))



(add-hook 'lisp-mode-hook '(lambda ()
  (local-set-key (kbd "RET") 'newline-and-indent)))


(fset 'slot-expansion3
   [?\C-b ?\C-  ?\C-\M-b ?\M-w ?\C-\M-f ?  ?: ?a ?c ?c ?e ?s ?s ?o ?r ?  ?\C-y ?  ?: ?i ?n ?i ?t ?a ?r ?g ?  ?: ?\C-y ?  ?: ?i ?n ?i ?t ?f ?o ?r ?m ?  ?n ?i ?l ?\C-e ?\C-\M-f])
(global-set-key (kbd "C-c a") 'slot-expansion3)
