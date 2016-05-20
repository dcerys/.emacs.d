
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
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
