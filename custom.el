
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cider-cljs-lein-repl
   "(do (require 'weasel.repl.websocket) (cemerick.piggieback/cljs-repl (weasel.repl.websocket/repl-env :ip \"127.0.0.1\" :port 9001)))")
 '(coffee-tab-width 2)
 '(package-selected-packages
   (quote
    (magit-filenotify company tagedit tabbar smex smartparens slime rainbow-delimiters projectile paredit markdown-mode magit-annex ido-ubiquitous exec-path-from-shell clojure-mode-extra-font-locking cider)))
 '(safe-local-variable-values
   (quote
    ((Package . CL-USER)
     (TeX-master . "tacs")
     (TeX-master . t)
     (Base . 10)
     (Package . CL-FAD)
     (Syntax . COMMON-LISP)
     (package . common-lisp-user)
     (Syntax . ANSI-Common-Lisp)
     (package . shop2)
     (Package . CCL)
     (TeX-master . "main.tex")
     (TeX-PDF-mode . t)
     (TeX-master . "main")
     (Syntax . Common-Lisp))))
 '(server-done-hook (quote ((lambda nil (kill-buffer nil)) delete-frame)))
 '(server-switch-hook
   (quote
    ((lambda nil
       (let
           (server-buf)
         (setq server-buf
               (current-buffer))
         (bury-buffer)
         (switch-to-buffer-other-frame server-buf))))))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
