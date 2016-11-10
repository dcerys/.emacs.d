;; Sets up exec-path-from shell
;; https://github.com/purcell/exec-path-from-shell
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  ;; See https://github.com/purcell/exec-path-from-shell/issues/41
  (setq exec-path-from-shell-arguments
        (remove "-i" exec-path-from-shell-arguments))
  (exec-path-from-shell-copy-envs
   '("PATH")))


(setenv "PAGER" "cat")
