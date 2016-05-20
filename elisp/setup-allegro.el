;; this should fix the stupid allegro find-tag goofiness.
(setq fi:find-tag-lock nil)

;; I hate it that they highjack my emacs-lisp mode...[1998/10/21:goldman]
;; if you don't do this you get Allegro's emacs lisp mode instead of
;; the usual one...
(setq fi:define-emacs-lisp-mode nil)

(defvar fi:allegro-program-name "alisp")

;;; This sets up the paths you need and loads the right file...
;;; ALLEGRO-DIRECTORY must be bound in .emacs (or other upstream-loaded file)
(let ((allegro-path allegro-directory))
  (add-to-load-path (expand-file-name
		     (let ((case-fold-search t))
		       (if (featurep 'xemacs)
			   "xeli/"
			 "eli/"))
		     allegro-path))
  (load "fi-site-init")
  (setq fi:common-lisp-image-name (expand-file-name
                                   fi:allegro-program-name allegro-path))
  )

;;; this you need to run lisp on a machine other than the one your
;;; emacs is on...
;; (when acl-on-network
;;   (setq fi:emacs-to-lisp-transaction-directory (expand-file-name "~/tmp")))

;;; I like using the common-lisp smart indenter
(load-library "cl-indent")

(make-variable-buffer-local 'vc-diff-switches)

;;;---------------------------------------------------------------------------
;;; Lots of stuff because I didn't like the built in keymap...
;;;---------------------------------------------------------------------------
(add-hook 'fi:lisp-mode-hook
          (function
           (lambda ()
            (setq indent-line-function 'lisp-indent-line)
            (let ((map (current-local-map)))
              (define-key map (kbd "<f3>") 'insert-section-comment)
              (define-key map (kbd "<f4>") 'insert-file-comment)
              (define-key map "]" 'fi:super-paren)
              (define-key map "\C-c."   'find-tag)
              (define-key map "\C-c,"   'tags-loop-continue)
              (define-key map "\e."     'fi:lisp-find-definition)
              (define-key map "\e,"     'fi:lisp-find-next-definition)
              (define-key map "\C-ca" 'fi:lisp-arglist)
              (define-key map "\C-cA" 'fi:lisp-apropos)
              (define-key map "\C-cd" 'fi:lisp-function-documentation)
              (define-key map "\t" 'lisp-indent-line)
              (define-key map "\C-j" 'newline-and-indent)
              (define-key map "\C-cD" 'fi:clman)
              (define-key map "\M-\C-h" 'indent-sexp)
              (define-key map "\C-cw" 'fi:lisp-compile-region)
              (define-key map (kbd "M-<backspace>") nil)
              ;; compatibility with SLIME
              (define-key map "\C-c\C-w"
                'fi:list-who-calls)
              )
            (setq vc-diff-switches (list "-u" "-F" "'^(def'"))
            )))

(add-hook 'fi:common-lisp-mode-hook
          (function
           (lambda ()
            ;; the following is idiotically defined to be indent-sexp,
            ;; instead of the standard, backward-kill-word. [2003/10/30:rpg]
            (define-key fi:common-lisp-mode-map
                    (kbd "M-<backspace>")
                    nil)
            (define-key fi:common-lisp-mode-map
                (if lucid-emacs-p '(meta tab) (kbd "M-<tab>"))
              'fi:lisp-complete-symbol)
            (let ((map (current-local-map)))
              (define-key map (if lucid-emacs-p [f5] '[f5]) 'fi:edit-who-calls)
              (define-key map "\C-cc" 'fi:lisp-eval-or-compile-defun)
              (define-key map "\C-cw" 'fi:lisp-eval-or-compile-region)))))

(defun fi:toggle-to-lisp-other-window ()
  "On each invocation, jump back and forth between the Lisp subprocess
buffer and the source buffer from which this function was invoked."
  (interactive)
  (when (one-window-p)(split-window))
  ;; this actually won't work from the common-lisp mode window,
  ;; because if you change to the other window *first*, then you're in
  ;; a lisp-mode buffer, and will just move that one to the inferior
  ;; common lisp buffer, instead of being back in the lisp window...
  (other-window 1)
  (fi:toggle-to-lisp))

(add-hook 'fi:common-lisp-mode-hook
          ;; add the tempo-templates....
          ;; [2002/01/24:goldman])
          (function
           (lambda ()
             (define-key fi:common-lisp-mode-map "\C-c4l"
               'fi:toggle-to-lisp-other-window)
;; not working yet...
;(define-key fi:inferior-common-lisp-mode-map "\C-c4l"
;  'fi:toggle-to-lisp-other-window)
    )))

;; (autoload 'make-cl-tempo-map "cl-templates"
;;   "Install a substidiary keymap for tempo templates
;; of CL forms.")

;; (add-hook 'fi:common-lisp-mode-hook
;;           ;; add the tempo-templates....
;;           ;; [2002/01/24:goldman])
;;           (function
;;            (lambda ()
;;             (let ((map (current-local-map)))
;;               (make-cl-tempo-map map)))))

;;; I hope that the following will no longer be necessary because of turning on
;;; global font-lock. [2008/06/20:rpg]

;;; for some dang reason this simply *does not work* on Aquamacs. [2008/04/18:rpg]
;;(add-hook 'fi:common-lisp-mode-hook 'turn-on-font-lock)


;(add-hook 'fi:common-lisp-mode-hook
;         (function (lambda () (setq tab-width 4))))

;; experimental...
;(add-hook 'fi:common-lisp-mode-hook
;         (function
;          (lambda ()
;           (when (string-equal (buffer-file-name)
;                             "domain.lisp")
;             (prodigy-mode 1)))))

;;(load-library "cl-templates")

;;;---------------------------------------------------------------------------
;;; Make sure the comments are autoloaded
;;;---------------------------------------------------------------------------

(autoload 'insert-file-comment
    "lisp-comment-utils"
  "Inserts a file header comment"
  t)

;;;---------------------------------------------------------------------------
;;; get the indentation to work right...
;;;---------------------------------------------------------------------------
;(require 'cl-indent-rpg)

;;;---------------------------------------------------------------------------
;;; for allegro
;;;---------------------------------------------------------------------------
;;(def-lisp-indentation top-level:alias (4 (&whole 4 &rest 1) &body))

;;;---------------------------------------------------------------------------
;;; Fix the way emacs groups buffers so that inferior lisp buffers get
;;; glonked in with lisp mode ones.
;;;---------------------------------------------------------------------------
;; (when lucid-emacs-p
;;   (add-to-list 'buffers-tab-grouping-regexp
;;              "^\\(fi:common-lisp-mode\\|fi:inferior-common-lisp-mode\\|fi:lisp-listener-mode\\)"))

;;;---------------------------------------------------------------------------
;;; Here's something that claims to do better arglist printing...
;;;
;;; As of today, seems to break ELI. [2010/11/18:rpg]
;;;---------------------------------------------------------------------------

;;;The following is an adaptation of the code from ILISP - it's not
;;;rigorous, but it seems to do the job:
;; (defun eli-arglist-lisp-space ()
;;   "Displays the value of the argument list of a symbol followed by
;; #\\Space.
;; This function is intended to be bound to the #\\Space key so that,
;; after being enabled it will display the arglist or value of a specific
;; symbol after the symbol has been typed in followed by #\\Space."
;;   (interactive)
;;   (let* ((old-point (point))
;;   (last-char (progn (ignore-errors (backward-char))
;;       (unless (eql (point) old-point)
;;         (buffer-substring-no-properties old-point (point)))))
;;   (string
;;    (buffer-substring-no-properties old-point
;;        (progn
;;          (goto-char old-point)
;;          (ignore-errors (backward-sexp))
;;          (point))))
;;   (prefix-char
;;    (let ((save (ignore-errors
;;    (goto-char old-point)
;;    (backward-sexp)
;;    (backward-char)
;;    (point))))
;;      (when save
;;        (buffer-substring-no-properties save (1+ save)))))
;;   (double-quote-pos (and string (string-match "\"" string)))
;;   (paren-pos (and string
;;     (string-match "(" string)))
;;   (symbol-with-package
;;    (unless (eql paren-pos 0)
;;      (if (and double-quote-pos (eql double-quote-pos 0)
;;        string (ignore-errors (elt string 2)))
;;   (substring string 1 -1)
;;   string)))
;;   (symbol symbol-with-package))
;;     (flet ((no-arglist-output-p ()
;;     (or (and last-char
;;       (or ;; don't do silly things after comment character
;;        (equal last-char ";")
;;        ;; do something only if directly after a sexp.
;;        (equal last-char " ")))
;;         ;; could be something like #+foo, #-foo, or #:foo, any of
;;         ;; which is likely to lose.
;;         (and string
;;       (string-match "^#" string))
;;         double-quote-pos ;; there is no output  for strings only.
;;         (not (and symbol (stringp symbol) (> (length symbol) 0)))
;;         (string-match "^\. " symbol)
;;         (string-match "^\\\\" symbol))))

;;       (goto-char old-point)
;;       (unless (no-arglist-output-p)
;;  ;; only output for functions within brackets; too much lisp-traffic!
;;  (when (equal prefix-char "(")
;;    (fi::make-request (lep::arglist-session :fspec string)
;;        ;; Normal continuation
;;        (() (what arglist)
;;         (fi:show-some-text nil "%s's arglist: %s" what arglist))
;;        ;; Error continuation
;;        ((string) (error)
;;         (fi::show-error-text "")))))))
;;   (self-insert-command (prefix-numeric-value current-prefix-arg)))

;; (add-hook 'fi:lisp-mode-hook
;;   (function
;;    (lambda ()
;;     (let ((map (current-local-map)))
;;       (define-key map " "       'eli-arglist-lisp-space)))))

;; From Will Fitzgerald.  Makes C-up and C-down act like C-c C-p
;; and C-c C-n respectively, in a lisp interaction buffer.


(add-hook 'fi:lisp-listener-mode-hook
            (function
             (lambda ()
;;            (define-key fi:lisp-listener-mode-map '(control up)   'fi:pop-input)
;;            (define-key fi:lisp-listener-mode-map  '(control down) 'fi:push-input)
              (define-key fi:lisp-listener-mode-map  (kbd "M-<tab>") 'fi:lisp-complete-symbol))))

(add-hook 'fi:inferior-common-lisp-mode-hook
          (function
           (lambda ()
            (when lucid-emacs-p
              (define-key fi:inferior-common-lisp-mode-map '(control up)   'fi:pop-input)
              (define-key fi:inferior-common-lisp-mode-map  '(control down) 'fi:push-input))
            (define-key fi:inferior-common-lisp-mode-map
                (if lucid-emacs-p
                    '(meta tab) (kbd "M-<tab>"))
              'fi:lisp-complete-symbol)
            )))

;;;---------------------------------------------------------------------------
;;; Get the hyperspec!
;;; ---------------------------------------------------------------------------
;;; FIXME: Not sure this is needed any more, since the hyperspec is included in
;;; the allegro manual.  [2013/04/22:rpg]
;; (require 'hyperspec "orig-hyperspec")
;; (require 'hyperspec-addon)
(add-hook 'fi:common-lisp-mode-hook
          (function (lambda ()
            (define-key fi:common-lisp-mode-map
                (if lucid-emacs-p [f6] '[f6])
              'fi:manual)
            )))
(add-hook 'fi:inferior-common-lisp-mode-hook
          (function
           (lambda ()
            (define-key fi:inferior-common-lisp-mode-map (if lucid-emacs-p [f6] '[f6])
              'fi:manual)
            )))

;;;---------------------------------------------------------------------------
;;; How about the lisp dictionary...
;;;---------------------------------------------------------------------------
(defun lispdoc ()
   "searches lispdoc.com for SYMBOL, which is by default the symbol
 currently under the curser"
   (interactive)
   (let* ((word-at-point (word-at-point))
          (symbol-at-point (symbol-at-point))
          (default (symbol-name symbol-at-point))
          (inp (read-from-minibuffer
                (if (or word-at-point symbol-at-point)
                    (concat "Symbol (default " default "): ")
                    "Symbol (no default): "))))
     (if (and (string= inp "") (not word-at-point) (not
 symbol-at-point))
         (message "you didn't enter a symbol!")
         (let ((search-type (read-from-minibuffer
                             "full-text (f) or basic (b) search (default b)? ")))
           (browse-url (concat "http://lispdoc.com?q="
                               (if (string= inp "")
                                   default
                                   inp)
                               "&search="
                               (if (string-equal search-type "f")
                                   "full+text+search"
                                   "basic+search")))))))



(add-hook 'fi:common-lisp-mode-hook
          (function (lambda ()
            (define-key fi:common-lisp-mode-map
                (if lucid-emacs-p [f7] '[f7])
              'lispdoc)
            )))

(add-hook 'fi:inferior-common-lisp-mode-hook
          (function
           (lambda ()
            (define-key fi:inferior-common-lisp-mode-map (if lucid-emacs-p [f7] '[f7])
              'lispdoc)
            )))

;;;---------------------------------------------------------------------------
;;; OK, how about the Allegro manuals? [2006/04/18:rpg]
;;;---------------------------------------------------------------------------

;;(require 'allegro-manual)
;;(setq acl-manual-root (concat allegro-directory "/doc/"))
(defalias 'allegro-manual 'fi:manual)
(add-hook 'fi:common-lisp-mode-hook
          (function (lambda ()
            (define-key fi:common-lisp-mode-map
                (if lucid-emacs-p [f10] '[f10])
              'allegro-manual)
            )))
(add-hook 'fi:inferior-common-lisp-mode-hook
          (function
           (lambda ()
            (define-key fi:inferior-common-lisp-mode-map (if lucid-emacs-p [f10] '[f10])
              'allegro-manual)
            )))

;;;---------------------------------------------------------------------------
;;; Fix fi:lisp-complete-symbol to work with mlisp
;;;---------------------------------------------------------------------------
(defun fi::mlisp-p ()
  (fi:eval-in-lisp "(eq excl::*current-case-mode* :case-sensitive-lower)"))



(defun fi:lisp-complete-symbol ()
  "Perform completion on the Common Lisp symbol preceding the point.  That
symbol is compared to symbols that exist in the Common Lisp environment.
If the symbol starts just after an open-parenthesis, then only symbols (in
the Common Lisp) with function definitions are considered.  Otherwise all
symbols are considered.  fi:package is used to determine from which Common
Lisp package the operation is done.  In a subprocess buffer, the package is
tracked automatically.  In source buffer, the package is parsed at file
visit time.

Abbreviations are also expanded.  For example, in the initial `user'
package, which inherits symbols from the `common-lisp' package, ``m-p-d-''
will expand to ``most-positive-double-float''.  The hyphen (-) is a
separator that causes the substring before the hyphen to be matched at the
beginning of words in target symbols."
  (interactive)
  (let* ((end (point))
         xpackage real-beg
         (beg (save-excursion
                (backward-sexp 1)
                (while (= (char-syntax (following-char)) ?\')
                  (forward-char 1))
                (setq real-beg (point))
                (let ((opoint (point)))
                  (if (re-search-forward ":?:" end t)
                      (setq xpackage
                        (concat
                         ":"
                         (fi::defontify-string
                             (buffer-substring opoint (match-beginning 0)))))))
                (point)))
         (pattern (fi::defontify-string (buffer-substring beg end)))
         (functions-only (if (eq (char-after (1- real-beg)) ?\() t nil))
         (downcase (and (not (fi::mlisp-p)) (not (fi::all-upper-case-p pattern))))
         (xxalist (fi::lisp-complete-1 pattern xpackage functions-only))
         temp
         (package-override nil)
         (xalist
          (if (and xpackage (cdr xxalist))
              (fi::package-frob-completion-alist xxalist)
            (if (and (not xpackage)
                     ;; current package of buffer is not the same as the
                     ;; single completion match
                     (null (cdr xxalist)) ;; only one
                     (setq temp (fi::extract-package-from-symbol
                                 (cdr (car xxalist))))
                     (not
                      (string= (fi::full-package-name
                                (or (fi::package) "cl-user"))
                               (fi::full-package-name temp))))
                (progn
                  (setq package-override t)
                  xxalist)
              xxalist)))
         (alist (if downcase
                    (mapcar 'fi::downcase-alist-elt xalist)
                  xalist))
         (completion
          (when alist
            (let* ((xfull-package-name
                    (if (string= ":" xpackage)
                        "keyword"
                      (when xpackage
                        (fi::full-package-name xpackage))))
                   (full-package-name
                    (when xfull-package-name
                      (if downcase
                          (downcase xfull-package-name)
                        xfull-package-name))))
              (when (or full-package-name package-override)
                (setq pattern
                  (format "%s::%s" full-package-name pattern)))
              (try-completion pattern alist)))))

    (cond ((eq completion t)
           (message "Completion is unique."))
          ((and (null completion) (null alist))
           (message "Can't find completion for \"%s\"" pattern)
           (ding))

;;;; the next three clauses are for abbrev expansion:

          ((and (null completion) alist (null (cdr alist)))
           (delete-region real-beg end)
           (insert (cdr (car alist))))

          ((and (null completion) alist)
           ;; pattern is something like l-a-comp.  The next hack is to turn
           ;; this into something like list-all-comp...
           (delete-region real-beg end)
           (insert (fi::abbrev-to-symbol pattern alist))

           (message "Making completion list...")
           (with-output-to-temp-buffer "*Completions*"
             (display-completion-list (mapcar 'cdr alist)))
           (message "Making completion list...done"))

          ((and (cdr alist)
                (or
                 ;; there is a match, but there are other possible
                 ;; matches
                 (string= pattern completion)
                 ;; more than one choice, so insert what completion we have
                 ;; and give the choices to the user
                 (not (assoc pattern alist))))
           (if xpackage
               (delete-region real-beg end)
             (delete-region beg end))
           (insert completion)
           (message "Making completion list...")
           (with-output-to-temp-buffer "*Completions*"
             (display-completion-list
              (mapcar 'cdr alist))))
;;;;

          ((null (string= pattern completion))
           (let ((new (cdr (assoc completion alist))))
             (if new
                 (progn
                   (delete-region real-beg end)
                   (insert new))
               (delete-region beg end)
               (insert completion)))
           (if (not (cdr alist))
               (message "Completion is unique.")))
          (t
           (message "Making completion list...")
           (with-output-to-temp-buffer "*Completions*"
             (display-completion-list
              (mapcar 'cdr alist)))
           (message "Making completion list...done")))))


;;;---------------------------------------------------------------------------
;;; xemacs doesn't have make-backup-file-name-1
;;;---------------------------------------------------------------------------
(when (and lucid-emacs-p
           (not (fboundp 'make-backup-file-name-1)))
  (autoload 'make-backup-file-name-1 "xemacs-backup-file"
    "Replacement for FSF emacs function, needed by ELI,
in xemacs."))

;;;---------------------------------------------------------------------------
;;; On aquamacs, kill the stupid use of ? as a prefix key...
;;;---------------------------------------------------------------------------
(when aquamacs-p
  (add-hook 'fi:inferior-common-lisp-mode-hook
            (lambda () (define-key fi:inferior-common-lisp-mode-map "?" 'self-insert-command)))
  (add-hook 'fi:common-lisp-mode-hook
            (lambda () (define-key fi:common-lisp-mode-map "?" 'self-insert-command))))

;;;---------------------------------------------------------------------------
;;; On aquamacs, need to set the color theme for each window (groan)
;;;---------------------------------------------------------------------------
;;; pulling the color theme for now... [2008/08/04:rpg]
;; (when aquamacs-p
;;   (add-hook 'fi:common-lisp-mode-hook
;;          'color-theme-subtle-hacker))

;;;---------------------------------------------------------------------------
;;; when you list callers, you get into lisp-definition mode
;;;---------------------------------------------------------------------------
(add-hook 'fi:definition-mode-hook
          (lambda ()
            (define-key fi:definition-mode-map (kbd "M-.")
              'fi:definition-mode-goto-definition)))


;;;---------------------------------------------------------------------------
;;; Kill all the bloody tab characters
;;;---------------------------------------------------------------------------
(add-hook 'fi:common-lisp-mode-hook
          '(lambda ()
            (make-local-variable 'write-contents-hooks)
            (add-hook 'write-contents-hooks 'kill-all-tabs)
            (add-hook 'write-contents-hooks
             '(lambda () (set-buffer-file-coding-system 'unix) nil))
            ;; (setq show-trailing-whitespace t)
            ))

;;;---------------------------------------------------------------------------
;;; Use fic mode and configure it...
;;;---------------------------------------------------------------------------
;; (add-hook 'fi:common-lisp-mode-hook
;;           '(lambda ()
;;             (turn-on-fic-mode)
;;             (make-variable-buffer-local 'fic-search-list-re)
;;             (setq fic-search-list-re "\\<\\(BUG\\|FIXME\\|KLUDGE\\|TODO\\)")))

;;;---------------------------------------------------------------------------
;;; Special startup
;;;---------------------------------------------------------------------------

(setq alisp-executable "alisp")

;;; should modify this to take an optional argument indicating whether to use
;;; local overrides or not. [2010/01/25:rpg]
(defun poirot-lisp ()
     (interactive)
     (fi:common-lisp "*common-lisp*" "~/integrated-learning/poirot/"
                mlisp-executable
                '("-q" "-L" "~/clinit.cl" "-e" "(poirot\ nil)")
                "localhost")
;;      (setq fi:common-lisp-image-name mlisp-executable)
;;      (setq fi:common-lisp-directory "~/integrated-learning/poirot/")
;;      ;;somehow the following works, but the poirot function
;;      ;; isn't getting executed [2009/11/16:rpg]
;;      (setq fi:common-lisp-image-arguments '("-q" "-L" "~/clinit.cl" "-e" "(poirot)"))
;;      (fi:common-lisp)
     )

(defun stratus-lisp ()
  (interactive)
  (let ((fi:common-lisp-image-arguments nil))
    (fi:common-lisp "*common-lisp*" "~/stratus-dev/stratus/code"
                    alisp-executable
                    nil
                    "localhost"
                    "~/stratus-dev/stratus/code/bin/stratus.dxl")))

(defun stratus-web-demo ()
     (interactive)
     (fi:common-lisp "*common-lisp*" "~/stratus-dev/stratus/code"
                alisp-executable
                '("-q" "-L" "~/clinit.cl" "-e"
                      "(progn (asdf:load-system \"stratus-web-demo\") (uiop:symbol-call :stratus-web-demo '#:start-server) (uiop:symbol-call :net.aserve '#:debug-on :all))")
                "localhost"
                "~/stratus-dev/stratus/code/bin/stratus.dxl"))

(defun fi:check-unbalanced-parentheses-when-saving ()
  (if (and fi:check-unbalanced-parentheses-when-saving
           (memq major-mode '(fi:common-lisp-mode fi:emacs-lisp-mode
                              fi:franz-lisp-mode)))
      (if (eq 'warn fi:check-unbalanced-parentheses-when-saving)
          (save-excursion
            (condition-case nil
                (progn (fi:find-unbalanced-parenthesis) nil)
              (error
               (message "Warning: parens are not balanced in this buffer.")
               (ding)
               (sit-for 2)
               ;; so the file is written:
               nil)))
        (condition-case nil
            (save-excursion (fi:find-unbalanced-parenthesis) nil)
          (error
           ;; save file if user types "yes":
           (not (y-or-n-p "Parens are not balanced.  Save file anyway? ")))))))

;;;---------------------------------------------------------------------------
;;; Suggestion from Dan
;;;---------------------------------------------------------------------------
(add-hook 'fi:common-lisp-mode-hook
          (lambda ()
            (setq imenu-generic-expression lisp-imenu-generic-expression)))

;;;---------------------------------------------------------------------------
;;; Keep me from being confused b/w ELI and SLIME
;;;---------------------------------------------------------------------------
(defalias 'alisp 'fi:common-lisp)


;;;---------------------------------------------------------------------------
;;; emulate SLIME feature of synchronizing buffer with REPL
;;; doesn't yet work...
;;;---------------------------------------------------------------------------
(defun fi-rpg-sync-package ()
  (interactive)
  (let ((package fi:package))
    (save-excursion
      (fi:toggle-to-lisp)
      (fi:eval-in-lisp "(in-package \"%s\")" (upcase package)))))

(provide 'fi-rpg-custom)
