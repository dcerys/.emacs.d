(require 'cl)

;; To address an emacs package loading problem in Emacs 26.2
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(defun add-to-load-path (dir)
  (push dir load-path))
(defvar my-init-file-root "~/.emacs.d/elisp/")
(push my-init-file-root load-path)
;(push (concat my-init-file-root "tabbar") load-path)
;(push (concat my-init-file-root "markdown-mode") load-path)

(setq lucid-emacs-p nil) ;;legacy support
(setq aquamacs-p nil) ;;more legacy

;; basic initialization, (require) non-ELPA packages, etc.
(setq package-enable-at-startup nil)

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("tromey" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

;; Load and activate emacs packages. Do this first so that the
;; packages are loaded before you start trying to modify them.
;; This also sets the load path.
(package-initialize)

;; Download the ELPA archive description if needed.
;; This informs Emacs about the latest versions of all packages, and
;; makes them available for download.
(when (not package-archive-contents)
  (package-refresh-contents))

;; The packages you want installed. You can also install these
;; manually with M-x package-install
;; Add in your own as you wish:
(defvar my-packages
  '(;; makes handling lisp expressions much, much easier
    ;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
    paredit

    ;; https://github.com/Fuco1/smartparens
    smartparens

    ;; key bindings and code colorization for Clojure
    ;; https://github.com/clojure-emacs/clojure-mode
    clojure-mode

    ;; extra syntax highlighting for clojure
    clojure-mode-extra-font-locking

    ;; integration with a Clojure REPL
    ;; https://github.com/clojure-emacs/cider
    cider

    slime

    ;; allow ido usage in as many contexts as possible. see
    ;; customizations/navigation.el line 23 for a description
    ;; of ido
    ;; ido-ubiquitous
    ido-completing-read+

    ;; Enhances M-x to allow easier execution of commands. Provides
    ;; a filterable list of possible commands in the minibuffer
    ;; http://www.emacswiki.org/emacs/Smex
    smex

    ;; project navigation
    projectile

    ;; colorful parenthesis matching
    rainbow-delimiters

    ;; edit html tags like sexps
    tagedit

    markdown-mode

    ;; tabbar

    ;; git integration
    ;; Let's wait until we have emacs 24.4 on all my machines
    magit
    magit-popup

    elpy
    ))

;; On OS X, an Emacs instance started from the graphical user
;; interface will have a different environment than a shell in a
;; terminal window, because OS X does not run a shell during the
;; login. Obviously this will lead to unexpected results when
;; calling external utilities like make from Emacs.
;; This library works around this problem by copying important
;; environment variables from the user's shell.
;; https://github.com/purcell/exec-path-from-shell
(if (eq system-type 'darwin)
    (add-to-list 'my-packages 'exec-path-from-shell))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;;;;
;; Customization
;;;;

;; All of the following are in the "~/.emacs.d/elisp" directory

;; Sets up exec-path-from-shell so that Emacs will use the correct
;; environment variables
(load "shell-integration.el")

;; These customizations make it easier for you to navigate files,
;; switch buffers, and choose options from the minibuffer.
(load "navigation.el")

;; These customizations change the way emacs looks and disable/enable
;; some user interface elements
(load "ui.el")

;; These customizations make editing a bit nicer.
(load "editing.el")

;; Hard-to-categorize customizations
(load "misc.el")

;; For editing lisps
(load "elisp-editing.el")

;; Language-specific
(load "setup-clisp.el")
(load "setup-clojure.el")
(load "setup-js.el")
(load "setup-python.el")


;; (require) your ELPA packages, configure them as normal
;(require 'tabbar)

(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
;;(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(autoload 'aadl-mode "aadl-mode"
   "Major mode for editing AADL files" t)
(add-to-list 'auto-mode-alist '("\\.aadl\\'" . aadl-mode))

;;; Setup Org mode
;; The following lines are always needed.  Choose your own keys.
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
;     (global-set-key "\C-cl" 'org-store-link)
;     (global-set-key "\C-ca" 'org-agenda)
 ;    (global-set-key "\C-cb" 'org-iswitchb)




(add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))

(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist
      (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))
(defun my-csharp-mode-fn ()
  "function that runs when csharp-mode is initialized for a buffer."
  (turn-on-auto-revert-mode)
  (setq indent-tabs-mode nil)
  (require 'flymake)
  ;(flymake-mode 1)
  ;(require 'yasnippet)
  ;(yas/minor-mode-on)
  ;(require 'rfringe)
  )
(add-hook  'csharp-mode-hook 'my-csharp-mode-fn t)


;;; Setup praxis mode
(when (< emacs-major-version 24) ;;Doesn't work in Emacs 24
  (load "~/.emacs.d/elisp/praxis-mode.el")
  (add-to-list 'auto-mode-alist '("\.prxo'" . praxis-ont-mode))
  (autoload 'praxis-ont-mode "praxis-ont-mode" "Mode for praxis ontology files." t))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;; Prevent Extraneous Tabs
;;(setq-default indent-tabs-mode nil)
;; if indent-tabs-mode is off, untabify before saving
;; (add-hook 'write-file-hooks
;;           (lambda () (if (not indent-tabs-mode)
;;                          (untabify (point-min) (point-max)))
;;             nil ))

(setq-default fill-column 80)


(setq buffer-menu-buffer-font-lock-keywords
      '(("^....[*]Man .*Man.*"   . font-lock-variable-name-face) ;Man page
        (".*Dired.*"             . font-lock-comment-face)       ; Dired
        ("^....[*]shell.*"       . font-lock-preprocessor-face)  ; shell buff
        (".*[*]scratch[*].*"     . font-lock-function-name-face) ; scratch buffer
        ("^....[*].*"            . font-lock-string-face)        ; "*" named buffers
        ("^..[*].*"              . font-lock-constant-face)      ; Modified
        ("^.[%].*"               . font-lock-keyword-face)))     ; Read only

(defun buffer-menu-custom-font-lock  ()
      (let ((font-lock-unfontify-region-function
             (lambda (start end)
               (remove-text-properties start end '(font-lock-face nil)))))
        (font-lock-unfontify-buffer)
        (set (make-local-variable 'font-lock-defaults)
             '(buffer-menu-buffer-font-lock-keywords t))
        (font-lock-fontify-buffer)))

(add-hook 'buffer-menu-mode-hook 'buffer-menu-custom-font-lock)

;;; For emacsclient...
(server-start)

;; (when (eq system-type 'darwin)
;;   ;(set-default-font "-*-Courier-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1")
;;   ;(set-default-font "-apple-inconsolata-medium-r-normal--14-130-72-72-m-130-iso10646-1")
;;   (set-default-font "-apple-inconsolata-medium-r-normal--14-*-*-*-m-0-iso10646-1")
;;   )

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Include host-specific config:
(setq host-config (concat "~/.emacs.d/config/emacs-" (system-name) ".el"))
(if (file-exists-p host-config)
  (load host-config t t)
  (message "No host config specified"))
