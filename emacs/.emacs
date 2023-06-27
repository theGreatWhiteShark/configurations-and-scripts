;;;; customization

;; loading personal scripts and functions 
(defvar elisp-path '("~/git/configurations-and-scripts/emacs/elisp/"))
(mapcar #'(lambda(p) (add-to-list 'load-path p)) elisp-path)
;; Path to the lisp sources of Emacs
(setq emacs-lisp-source-path "~/git/emacs/lisp")

;; Using the MELPA repository (this has to be on top or packages
;; installed using MELPA will not be found by this script
(require 'package)
;; more packages
(setq package-archives
      '(("ELPA" . "http://tromey.com/elpa/")
	("gnu" . "http://elpa.gnu.org/packages/")
	("melpa" . "https://melpa.org/packages/")
	("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)

;; Use company for autocompletion
(add-to-list 'load-path
	     "~/git/configurations-and-scripts/emacs/company-mode")
(require 'company)
(require 'company-gtags)
(add-hook 'after-init-hook 'global-company-mode)

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t
	  company-frontends '(company-pseudo-tooltip-frontend))
(global-set-key (kbd "C-c c k") 'company-select-next-or-abort)
(global-set-key (kbd "C-c c l") 'company-select-previous-or-abort)
(global-set-key (kbd "C-c c i") 'company-complete-common-or-show-delayed-tooltip)
(global-set-key (kbd "C-c c m") 'company-complete-selection)
(global-set-key (kbd "C-c c s") 'company-filter-candidates)
(global-set-key (kbd "C-c c j") 'company-abort)
(global-set-key (kbd "C-c c ;") 'company-abort)

(global-set-key (kbd "C-S-l") 'company-select-previous-or-abort)
(global-set-key (kbd "S-TAB") 'company-complete-common-or-show-delayed-tooltip)
(global-set-key (kbd "C-S-s") 'company-filter-candidates)
(global-set-key (kbd "S-RET") 'company-complete-selection)
(global-set-key (kbd "C-S-j") 'company-abort)
(global-set-key (kbd "C-S-k") 'company-select-next-or-abort)
(global-set-key (kbd "C-:") 'company-abort)
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;; spell checking ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Activate on the fly spellchecking for all major modes I use on a
;; regular basis
(load-file "~/git/configurations-and-scripts/emacs/elisp/flyspell.el")
(require 'flyspell2)

;; The default dictionary to be used should be the English one
(setq flyspell-default-dictionary "en")
;; Use a central personal dictionary. (Via a symbolic link from the
;; git repository)
;; The personal dictionary has always to be of the same language as the
;; current used one!
(setq ispell-personal-dictionary "~/.emacs.d/.aspell.en.pws"
      ;; Increase the speed (since we are using the more slower aspell
      ;; instead of ispell)
      ispell-extra-args '("--sug-mode=fast"))

;; Add a german dictionary and the option of switching between
;; languages.
(defun flyspell-switch-dictionary()
  (interactive)
  ;; Change the default dictionary too.
  ;; Well, the functions have a `ispell' prefix. But in the background
  ;; the spell checking is using aspell instead. Be aware of this when
  ;; installing additional software packages.
  (if (string= ispell-current-dictionary "de")
      (setq ispell-personal-dictionary "~/.emacs.d/.aspell.en.pws")
    (setq ispell-personal-dictionary "~/.emacs.d/.aspell.de.pws"))
  (let* ((dic ispell-current-dictionary)
	 (change (if (string= dic "de") "en" "de")))
    (ispell-change-dictionary change)
    (message "Dictionary changed from %s to %s" dic change)))
(global-set-key (kbd "<f8>") 'flyspell-switch-dictionary)

;; Activating Flyspell in the whole buffer.
(dolist (hook '(text-mode-hook
		LaTeX-mode-hook
		markdown-mode-hook
		fundamental-mode-hook
		mutt-mode-hook
		org-mode-hook) t)
  (add-hook hook (lambda() (flyspell-mode 1))))
;; Activate Flyspell in the comments only.
(dolist (hook '(ess-mode-hook
		python-mode-hook
		web-mode-hook
		lisp-mode-hook
		emacs-lisp-mode-hook
		conf-mode-hook
		sh-mode-hook
		c-mode-hook
		lua-mode-hook
		nxml-mode-hook
		c++-mode-hook) t)
  (add-hook hook (lambda() (flyspell-prog-mode))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;; using ido ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'ido)
(ido-mode 1)
(ido-everywhere 1)

(use-package flx
  :ensure t
  :pin melpa)
(use-package flx-ido
  :ensure t
  :pin melpa
  :init
  (flx-ido-mode 1)
  (setq ido-enable-flex-matching t)
  (setq ido-use-faces nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;; using helm ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path
	     "~/git/configurations-and-scripts/emacs/helm")
(require 'helm)
(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-unset-key (kbd "C-x rb"))
(global-set-key (kbd "C-x rb") 'helm-bookmarks)

(global-set-key (kbd "C-c h l") 'helm-locate)
(global-set-key (kbd "C-c h s") 'helm-semantic-or-imenu)
(global-set-key (kbd "C-c h o") 'helm-occur)
(global-set-key (kbd "C-c h i") 'helm-info)
(global-set-key (kbd "C-c h r") 'helm-resume)
(global-set-key (kbd "C-c h SPC") 'helm-all-mark-rings)
(global-set-key (kbd "C-c h c") 'helm-calcul-expression)

;; General helm configuration
(setq helm-split-window-in-side-p t ;; open helm buffer in current
				    ;; window
      helm-move-to-line-cycle-in-source t ;; periodic boundary
					  ;; conditions in selection
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t ;; Show search in both the echo
      ;; line and in the first line of the current buffer.
      helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match t
      helm-semantic-fuzzy-match t
      )

;; Configure the handling of gtags
(use-package helm-gtags
  :ensure t
  :pin melpa
  :init
  (add-hook 'c-mode-hook 'helm-gtags-mode)
  (add-hook 'c++-mode-hook 'helm-gtags-mode)
  
  (setq helm-gtags-ignore-case t
		helm-gtags-auto-update t
		helm-gtags-use-input-at-cursor t
		helm-gtags-display-style 'detail
		helm-gtags-auto-update t
		helm-gtags-fuzzy-match t
		helm-gtags-pulse-at-cursor t
		helm-gtags-prefix-key "\C-cg"
		helm-gtags-suggested-key-mapping t
		helm-gtags-direct-helm-completing t)

  (global-set-key (kbd "C-c g a")
				  'helm-gtags-tags-in-this-function)
  (global-set-key (kbd "C-c g t") 'helm-gtags-find-tag)
  (global-set-key (kbd "C-c g p") 'helm-gtags-find-tag-from-here)
  (global-set-key (kbd "C-c g e") 'helm-gtags-fing-rtag)
  (global-set-key (kbd "C-c g s") 'helm-gtags-find-symbol)
  (global-set-key (kbd "C-c g f") 'helm-gtags-parse-file)
  (global-set-key (kbd "C-c g w") 'helm-gtags-select)
  (global-set-key (kbd "C-c g g") 'helm-gtags-dwim)
  (global-set-key (kbd "C-c g j") 'helm-gtags-pop-stack)
  (global-set-key (kbd "C-c g ;") 'helm-gtags-push-stack)
  (global-set-key (kbd "C-c g k") 'helm-gtags-next-history)
  (global-set-key (kbd "C-c g l") 'helm-gtags-previous-history)
  (global-set-key (kbd "C-c g r") 'helm-gtags-resume)
  (global-set-key (kbd "C-c g h") 'helm-gtags-show-stack)
  (global-set-key (kbd "C-c g c") 'helm-gtags-clear-all-stacks)
  (global-set-key (kbd "C-c g u") 'helm-gtags-update-tags))

(dolist (hook '(lisp-interaction-mode-hook
		emacs-lisp-mode-hook
		c-mode-hook
		c++-mode-hook
		dired-mode-hook
		eshell-mode-hook) t)
  (add-hook hook (lambda() (helm-gtags-mode 1))))

(use-package helm-ag
  :ensure t
  :pin melpa
  :init
  (setq helm-ag-base-command "ag --nocolor --nogroup --ignore-case")
  (setq helm-ag-insert-at-point 'symbol)
  (setq helm-ag-fuzzy-match t)
  (global-set-key (kbd "C-c a w") 'helm-ag)
  (global-set-key (kbd "C-c a e") 'helm-ag-this-file)
  (global-set-key (kbd "C-c a f") 'helm-do-ag)
  (global-set-key (kbd "C-c a s") 'helm-do-ag-this-file)
  ;; (global-set-key (kbd "C-c a s") 'helm-do-ag-this-file-or-occur)
  (global-set-key (kbd "C-c a p") 'helm-ag-project-root)
  (global-set-key (kbd "C-c a a") 'helm-do-ag-project-root)
  (global-set-key (kbd "C-c a v") 'helm-ag-buffers)
  (global-set-key (kbd "C-c a b") 'helm-do-ag-buffers)
  ;; move to point before jump
  (global-set-key (kbd "C-c a j") 'helm-ag-pop-stack)
  (global-set-key (kbd "C-c a c") 'helm-ag-clear-stack)
  (define-key helm-map (kbd "C-c l") 'helm-ag--up-one-level))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;; using projectile ;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package projectile
  :ensure t
  :pin melpa
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-c p" . projectile-command-map)))

;; Recursive discovery of known projects
(setq projectile-project-search-path '("~/git/"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;; ESS and R ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path
 	     "~/git/configurations-and-scripts/emacs/ESS/lisp"
 	     "~/git/configurations-and-scripts/emacs/ESS")
(require 'ess-site)

;; Specify the export options of polymode to accelerate the export of
;; .Rmd files.
(add-hook 'ess-mode-hook
	  (lambda()
	    (defvar pm--exporter-hist "Rmarkdown")
	    (defvar pm--export:to-last "html document (html)")
	    (defvar pm--export:to-hist "html document (html)")))

(setq
 ;;R-binary-folder "~/software/R/R-3.5.0/bin/"
 R-binary-folder "/usr/bin/R/")
 ;; inferior-R-program-name (concatenate 'string R-binary-folder "R")
 ;; AUCTeX interface for Sweave
 ;;ess-swv-plug-into-AUCTeX-p t
 ;; activating polymode and markdown-mode
 ;; load-path
 ;;(append
 ;; '("~/git/configurations-and-scripts/emacs/polymode/"
 ;;   "~/git/configurations-and-scripts/emacs/poly-R"
 ;;   "~/git/configurations-and-scripts/emacs/poly-noweb"
  ;;  "~/git/configurations-and-scripts/emacs/poly-markdown"
  ;;  "~/git/configurations-and-scripts/emacs/markdown-mode/")
 ;; load-path))
;;(require 'markdown-mode)
;;(require 'poly-R)
;;(require 'poly-markdown)
;; (add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
;;(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))

(setq
 ;; A comment is a comment. No matter how many dashes
 ess-indent-with-fancy-comments nil
 ;; Evaluate all code in the global namespace.
 ess-r-package-auto-enable-namespaced-evaluation nil
 ;; Try to complete statements
 ess-tab-complete-in-script 1
 ;; Use the GNU indentation style (2 whitespaces)
 ess-default-style 'GNU)
(defun myindent-ess-hook ()
  (setq ess-indent-level 2))
(add-hook 'ess-mode-hook 'myindent-ess-hook)
;; Use the old smart assign
(add-hook 'ess-mode-hook
	  (lambda()
	    (local-set-key (kbd "_") 'ess-insert-assign)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Go ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Run gofmt before saving a file.
;; (add-hook 'before-save-hook #'gofmt-before-save)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;; Python ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Use elpy with python-mode
;; (require 'elpy)
;; (add-hook 'python-mode-hook (lambda() (elpy-mode)))
;; (setenv "WORKON_HOME" "~/.virtualenvironments/")
;; (setenv "IPY_TEST_SIMPLE_PROMPT" "1")
;; (setq python-shell-interpreter "ipython3"
;;       python-shell-intepreter-args "-i")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; web-mode ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Be consistent and use web-mode for all web development stuff
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.scss\\'" . web-mode))
;; set indentation to 2
(add-hook 'web-mode-hook
	  (lambda()
	    (local-set-key [M-tab] 'web-mode-fold-or-unfold)
	    (setq web-mode-markup-indent-offset 2)
	    (setq web-mode-css-indent-offset 2)
	    (setq web-mode-code-indent-offset 2)
	    (local-set-key (kbd "M-;") 'windmove-right)
	    (local-set-key (kbd "M-'") 'web-mode-comment-or-uncomment)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;; Org Mode ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq load-path
      (cons "~/git/configurations-and-scripts/emacs/org-mode/lisp"
	    (cons
	     "~/git/configurations-and-scripts/emacs/org-mode/contrib/lisp"
	     load-path)))
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(require 'org)
;; Exporting Org files into various formats.
;;(require 'ox-html)
(require 'ox-latex)

;; (global-set-key "\C-ca" 'org-agenda)
(setq
 ;; My private files containing all different kinds of notes
 org-agenda-files (list
		   "~/git/orga/org/work.org"
		   "~/git/orga/org/private.org"
		   "~/git/orga/org/audio.org"
		   "~/git/orga/org/software.org")
 org-directory "~/git/orga/org"
 ;; Add a time stamp whenever a TODO item is marked as DONE
 org-log-done "time"
 ;; A parent task can only be switched to DONE when all its
 ;; children tasks were accomplished.
 org-enforce-todo-dependencies t
 ;; Display the agenda in a slightly more compact format.
 org-agenda-compact-blocks nil
 ;; Create an archive for each individual org file.
 org-archive-location "%s_archive::* Archived Tasks"
 ;; Don't ask for confirmation when evaluating code blocks in Org.
 org-confirm-babel-evaluate nil
 ;; Which R process to use when evaluating R code blocks. But I would
 ;; highly recommend to use ESS/polymode with Rmarkdown instead!
 ;; org-babel-R-command (concatenate 'string R-binary-folder
 ;; 				  "R --no-save --slave")
 ;; Which languages to evaluate in Org.
 org-babel-load-languages '((emacs-lisp . t)
			    (R . t)
			    (python . t)
			    (sh . t)
			    (org . t)
			    (latex . t))
 ;; Create a custom LaTeX class in order to export proper LaTeX
 ;; articles
 ;; http://www.draketo.de/english/emacs/writing-papers-in-org-mode-acpd
 org-latex-packages-alist '(("" "color" t)
			    ("" "graphicx" t)
			    ("sc" "mathpazo" t)
			    ("T1" "fontenc" t)
			    ("" "geometry" t)
			    ("" "alltt" t)
			    ("" "bm" t)
			    ("" "epsfig" t)
			    ("" "caption" t)
			    ("" "subcaption" t)
			    ("" "amssymb,amsmath" t)
			    ("unicode=true,pdfusetitle,
bookmarks=true,bookmarksnumbered=true,bookmarksopen=true,bookmarksopenlevel=2,
breaklinks=false,pdfborder={0 0 1},backref=false,colorlinks=false" "hyperref" t)
			    ("" "url" t))
 ;; Define a customized LaTeX export workflow
 org-latex-pdf-process
 '("pdflatex -interaction nonstopmode -shell-escape -output-directory latex/%o latex/%f"
   "bibtex latex/$basename %b)"
   "pdflatex -interaction nonstopmode -shell-escape -output-directory latex/%o latex/%f"
   "bibtex latex/$basename %b)"
   "pdflatex -interaction nonstopmode -shell-escape -output-directory latex/%o latex/%f")
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;; C/C++ & Qt & CEDET ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Globally enable Semantic mode
(require 'semantic)
(semantic-mode 1)

(use-package stickyfunc-enhance
  :ensure t
  :pin melpa)

;; Enable parsing via Semantic
(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
;; Display the interface of a function in the bottom minibuffer.
(global-semantic-idle-summary-mode 1)
;; Keep the line containing the definition of a function in the
;; top-most line
(add-to-list 'semantic-default-submodes
			 'global-semantic-stickyfunc-mode
			 'global-semantic-mru-bookmark-mode)

(define-key c++-mode-map (kbd "M-TAB") 'semantic-ia-complete-symbol)
(define-key c++-mode-map (kbd "C-c , f") 'semantic-ia-fast-jump)

;; Let semantic treat all folders in the `git` directory as larger
;; projects.
(setq semanticdb-project-roots
	  (directory-files (expand-file-name "~/git")
					   t "^\\([^.]\\|\\.[^.]\\|\\.\\..\\)")
	  semantic-complete-inline-analyzer-idle-displayer-class
	  'semantic-displayer-ghost)

;; Make Semantics aware of the Qt5 headers
(require 'semantic/bovine/c)
(require 'cc-mode)
(load (expand-file-name "find-file.el" emacs-lisp-source-path))
(setq qt-include-directory "/usr/include/x86_64-linux-gnu/qt5/")
(dolist (file (directory-files qt-include-directory))
  (let ((path (expand-file-name file qt-include-directory)))
    (when (and (file-directory-p path)
	       (not (or (equal file ".") (equal file ".."))))
      (progn
	(semantic-add-system-include path 'c++mode)
	(add-to-list 'cc-search-directories path)))))
;; Feed additional definitions of Qt5 to the lexical parser.
(dolist (file (list "QtCore/qconfig.h" "QtCore/qconfig-dist.h"
		    "QtCore/qconfig-large.h" "QtCore/qconfig-medium.h"
		    "QtCore/qconfig-minimal.h" "QtCore/qconfig-nacl.h"
		    "QtCore/qconfig-small.h" "QtCore/qglobal.h" ))
  (add-to-list 'semantic-lex-c-preprocessor-symbol-file
	       (expand-file-name file qt-include-directory)))
;; Some more on semantics
;; Display the interface of a function in the bottom minibuffer.
(global-semantic-idle-summary-mode 1)
;; Keep the line containing the definition of a function in the
;; top-most line
(add-to-list 'semantic-default-submodes
	     'global-semantic-stickyfunc-mode)

;; Use a dedicated mode for Qt build-system files
(add-to-list 'load-path
	     "~/git/configurations-and-scripts/emacs/qt-pro-mode")
(require 'qt-pro-mode)
(add-to-list 'auto-mode-alist '("\\.pr[io]$" . qt-pro-mode))

;; style I want to use in c++ mode
(c-add-style "my-style" 
			 '("stroustrup"
			   (indent-tabs-mode . t)        ; use spaces rather than tabs
			   (c-basic-offset . 4)            ; indent by four spaces
			   (c-indent-level . 4)
			   (c++-tab-always-indent . t)
			   (c-offsets-alist . ((namespace-open . 0)
								   (innamespace . 0)
								   (defun-open . +1)))))

(defun my-c++-mode-hook ()
  (c-set-style "my-style")        ; use my-style defined above
  (auto-fill-mode)
  (irony-mode)
  (flyspell-prog-mode)
  (helm-gtags-mode))

(add-hook 'c++-mode-hook 'my-c++-mode-hook)

;; Use C headers to complete in headers using company
(use-package company-c-headers
  :ensure t
  :pin melpa
  :init
  (add-to-list 'company-backends 'company-c-headers)
  (setq company-c-headers-path-system "/usr/include/c++/10/"))

;; Use the many window view of GDB. To use it, one must supply the
;; -i=mi argument to gdb
(setq gdb-many-windows 1
      gdb-show-main 1
	  gdb-speedbar-auto-raise t)

;; Use function-args-mode
(use-package function-args
  :ensure t
  :pin melpa)
(fa-config-default)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ibuffer ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Using 'ibuffer' to group buffer. This becomes handy when there is
;; a large amount of them.
(require 'ibuffer)
(setq ibuffer-saved-filter-groups
      '(("default"
	 ("Hydrogen core"
	  (filename . "/git/hydrogen*/src/core"))
	 ("Hydrogen gui"
	  (filename . "git/hydrogen*/src/gui/src/"))
	 ("Hydrogen tests"
	  (filename . "/git/hydrogen*/src/tests"))
	 ("Hydrogen"
	  (filename . "/git/hydrogen"))
	 ("Configuration"
	  (or
	   (filename . "/git/configurations-and-scripts")
	   (mode . conf-mode)))
	 ("Programming"
	  (or
	   (derived-mode . prog-mode)
	   (mode . c-mode)
	   (mode . c++-mode)
	   (mode . c-or-c++-mode)
	   (mode . cmake-mode)
	   (mode . typescript-mode)
	   (mode . web-mode)
	   (mode . python-mode)
	   (mode . sh-mode)
	   (mode . awk-mode)))
	 ("Org"
	  (mode . org-mode))
	 ("Dired" (mode . dired-mode))
	 ("Helm"
	   (name . "^\\*helm"))
	 ("Emacs"
	  (or
	   (mode . message-mode)
	   (mode . ess-mode)
	   (mode . emacs-lisp-mode)
	   (name . "\\*scratch\\*")
	   (name . "\\*Help\\*")
	   (name . "\\*Messages\\*")))
	 ("Interpreter"
	  (or
	   (name . "^\\*terminal\\*$")
	   (name . "\\*ESS\\*$")))
	 ("Web"
	  (or
	   (derived-mode . css-mode)
	   (mode . sass-mode)
	   (mode . web-mode))))))
(add-hook 'ibuffer-mode-hook
		  (lambda()
			(ibuffer-switch-to-saved-filter-groups "default")
			(setq ibuffer-hidden-filter-groups (list "Emacs" "Helm"))
			;; (ibuffer-update nil t)
			))
(global-set-key (kbd "C-x C-b") 'ibuffer)

(defun ajv/human-readable-file-sizes-to-bytes (string)
  "Convert a human-readable file size into bytes."
  (interactive)
  (cond
   ((string-suffix-p "G" string t)
    (* 1000000000 (string-to-number (substring string 0 (- (length string) 1)))))
   ((string-suffix-p "M" string t)
    (* 1000000 (string-to-number (substring string 0 (- (length string) 1)))))
   ((string-suffix-p "K" string t)
    (* 1000 (string-to-number (substring string 0 (- (length string) 1)))))
   (t
    (string-to-number (substring string 0 (- (length string) 1))))
   )
  )

(defun ajv/bytes-to-human-readable-file-sizes (bytes)
  "Convert number of bytes to human-readable file size."
  (interactive)
  (cond
   ((> bytes 1000000000) (format "%10.1fG" (/ bytes 1000000000.0)))
   ((> bytes 100000000) (format "%10.0fM" (/ bytes 1000000.0)))
   ((> bytes 1000000) (format "%10.1fM" (/ bytes 1000000.0)))
   ((> bytes 100000) (format "%10.0fk" (/ bytes 1000.0)))
   ((> bytes 1000) (format "%10.1fk" (/ bytes 1000.0)))
   (t (format "%10d" bytes)))
  )

;; Use human readable Size column instead of original one
(define-ibuffer-column size-h
  (:name "Size"
	 :inline t
	 :summarizer
	 (lambda (column-strings)
	   (let ((total 0))
	     (dolist (string column-strings)
	       (setq total
		     ;; like, ewww ...
		     (+ (float (ajv/human-readable-file-sizes-to-bytes string))
			total)))
	     (ajv/bytes-to-human-readable-file-sizes total)))	 ;; :summarizer nil
	 )
  (ajv/bytes-to-human-readable-file-sizes (buffer-size)))

;; Modify the default ibuffer-formats
(setq ibuffer-formats
      '((mark modified read-only locked " "
	      (name 20 20 :left :elide)
	      " "
	      (size-h 11 -1 :right)
	      " "
	      (mode 16 16 :left :elide)
	      " "
	      filename-and-process)
	(mark " "
	      (name 16 -1)
	      " " filename)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;; Diverse ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Enable the narrowing	     
(put 'narrow-to-region 'disabled nil)
;; And write a function that checks whether narrowing was activated.
;; This will be used in the mode line to display a customize note.
(defun narrowp ()
  "Checks whether or not narrowing is activated in the current buffer"
  (save-restriction
    (let (line-number-buffer line-number-buffer-widen)
      (setq line-number-buffer (count-lines (point-min) (point-max)))
      (widen)
      (setq line-number-buffer-widen
	    (count-lines (point-min) (point-max)))
      (if (> line-number-buffer-widen line-number-buffer) t
	nil))))

;; yasnippet
(load-file
 "~/git/configurations-and-scripts/emacs/yasnippet/yasnippet.el")
(require 'yasnippet)
(yas-global-mode 1)

;; but the prevents tab expansion in the terminal, so:
(add-hook 'term-mode-hook (lambda()
			    (setq yas-dont-activate t)))
;; Activate the Yasnippets-minor-mode in diverse modes
(dolist (hook '(ess-mode-hook
		markdown-mode-hook
		LaTeX-mode-hook
		Rnw-mode-hook) t)
  (add-hook hook (lambda() (yas-minor-mode 1))))
;; Be sure to bind the <Tab> in LaTeX-mode to Yasnippets
(add-hook 'LaTeX-mode-hook
	  (lambda() (local-set-key [tab] 'yas/expand)))

;; Show line numbers in all buffers
(global-display-line-numbers-mode 1)

;; Highlight changes in files under version control
(global-highlight-changes-mode t)
;; But hide this behaviour initially
(setq highlight-changes-visibility-initial-state nil)
;; Toggle the visibility
(global-set-key (kbd "<f6>") 'highlight-changes-visible-mode)
(set-face-background 'highlight-changes "#382f2f")
(set-face-background 'highlight-changes-delete "#916868")

;; Disable the very tricky command formatting all characters within a
;; region/paragraph to lower case. This caused quite a number of bugs.
(put 'downcase-region 'disabled t)

;; Change cursor color when pressing the 'insert' key
(defun set-cursor-according-to-mode ()
  "change cursor color to red if overwrite is activated"
  (cond (overwrite-mode
	 (set-cursor-color "red"))
	(t
	 (set-cursor-color "#dcdccc"))))
(add-hook 'post-command-hook 'set-cursor-according-to-mode)

;; Making buffer names unique
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward uniquify-separatir ":")

;; Uses abbreviations for the modes in the mode-line to shrink it down.
(when (require 'diminish nil 'noerror)
  (eval-after-load "yasnippet"
    '(diminish 'yas-minor-mode " Y")))
(add-hook 'emacs-lisp-mode-hook 
	  (lambda() (setq mode-name "el")))

;; Colorful delimiters 
(require 'rainbow-delimiters)
(dolist (hook '(emacs-lisp-mode-hook
		ess-mode-hook
		lisp-mode-hook
		python-mode-hook
		markdown-mode-hook
		web-mode-hook) t)
  (add-hook hook 'rainbow-delimiters-mode))

;; Changing the style of the mode-line
(setq-default mode-line-format
	      (list
	       ;; changes till last saving
	       '(:eval (when (buffer-modified-p)
			 (concat 
			  (propertize "[" 
				      'face 'font-lock-string-face)
			  (propertize "Mod"
				      'face 'font-lock-string-face
				      'help-echo "Buffer has been modified")
			  (propertize "] "
				      'face 'font-lock-string-face))))
	       ;; buffer/file name
	       '(:eval (propertize "%b " 'face 'font-lock-keyword-face 
				   'help-echo (buffer-file-name)))
	       ;; line and column
	       "(" 
	       (propertize "%02l" 'face 'font-lock-type-face)
	       ","
	       (propertize "%02c" 'face 'font-lock-type-face)
	       ") "
	       ;; check whether or not the buffer was narrowed
	       '(:eval (when (narrowp)
			 (propertize "[narrow] " 'face
				     'font-lock-string-face)))
	       ;; relative position/ size of file
	       "["
	       (propertize "%p" 'face 'font-lock-type-face)
	       "/"
	       (propertize "%I" 'face 'font-lock-type-face)
	       "] "
	       ;; current major mode
	       '(:eval (propertize "%m " 'face 'font-lock-keyword-face
				   'help-echo buffer-file-coding-system))
	       ;; readonly
	       '(:eval (when buffer-read-only
			 (concat " [" 
				 (propertize "readonly"
					     'face 'font-lock-type-face
					     'help-echo "Buffer is read-only")
				 "] ")))
	       ;; adding the time
	       '(:eval (propertize (format-time-string "%H:%M")
				   'face 'font-lock-constant-face
				   'help-echo
				   (concat (format-time-string "%c; ")
					   (emacs-uptime "Uptime: %hh"))))
	       " --"
	       ;; minor modes
	       minor-mode-alist
	       ))
;; Setting of the term colors. Unfortunately this is necessary since
;; using Emacs 24.3 and the zenburn theme
(defface term-color-black 
  '((t (:foreground "#3f3f3f" :background "#272822"))) 
  "Unhelpful docstring.")
(defface term-color-red
  '((t (:foreground "#cc9393" :background "#272822"))) 
  "Unhelpful docstring.")
(defface term-color-green
  '((t (:foreground "#7f9f7f" :background "#272822"))) 
  "Unhelpful docstring.")
(defface term-color-yellow
  '((t (:foreground "#f0dfaf" :background "#272822"))) 
  "Unhelpful docstring.")
(defface term-color-blue 
  '((t (:foreground "#8CD0D3" :background "#272822"))) 
  "Unhelpful docstring.")
(defface term-color-magenta 
  '((t (:foreground "#dc8cc3" :background "#272822"))) 
  "Unhelpful docstring.")
(defface term-color-cyan
  '((t (:foreground "#93e0e3" :background "#272822"))) 
  "Unhelpful docstring.")
(defface term-color-white
  '((t (:foreground "#dcdccc" :background "#272822"))) 
  "Unhelpful docstring.")
'(term-default-fg-color ((t (:inherit term-color-white))))
'(term-default-bg-color ((t (:inherit term-color-black))))

;; ansi-term colors
(add-hook 'term-mode-hook
	  (lambda()
	    (setq-default ansi-term-color-vector
			  [term term-color-black term-color-red
				term-color-green term-color-yellow 
				term-color-blue term-color-magenta
				term-color-cyan term-color-white])
	    (put 'narrow-to-region 'disabled nil)))
;; Reload the Emacs configuration file.
(defun reload ()
  (interactive)
  (load-file "~/.emacs"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#3F3F3F" "#CC93932" "#7F9F7F" "#F0DFAF" "#8CD0D3" "#DC8CC3" "#93E0E3" "#DCDCCC"])
 '(connection-local-criteria-alist
   '(((:application tramp)
	  tramp-connection-local-default-system-profile tramp-connection-local-default-shell-profile)))
 '(connection-local-profile-alist
   '((tramp-connection-local-darwin-ps-profile
	  (tramp-process-attributes-ps-args "-acxww" "-o" "pid,uid,user,gid,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state=abcde" "-o" "ppid,pgid,sess,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etime,pcpu,pmem,args")
	  (tramp-process-attributes-ps-format
	   (pid . number)
	   (euid . number)
	   (user . string)
	   (egid . number)
	   (comm . 52)
	   (state . 5)
	   (ppid . number)
	   (pgrp . number)
	   (sess . number)
	   (ttname . string)
	   (tpgid . number)
	   (minflt . number)
	   (majflt . number)
	   (time . tramp-ps-time)
	   (pri . number)
	   (nice . number)
	   (vsize . number)
	   (rss . number)
	   (etime . tramp-ps-time)
	   (pcpu . number)
	   (pmem . number)
	   (args)))
	 (tramp-connection-local-busybox-ps-profile
	  (tramp-process-attributes-ps-args "-o" "pid,user,group,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "stat=abcde" "-o" "ppid,pgid,tty,time,nice,etime,args")
	  (tramp-process-attributes-ps-format
	   (pid . number)
	   (user . string)
	   (group . string)
	   (comm . 52)
	   (state . 5)
	   (ppid . number)
	   (pgrp . number)
	   (ttname . string)
	   (time . tramp-ps-time)
	   (nice . number)
	   (etime . tramp-ps-time)
	   (args)))
	 (tramp-connection-local-bsd-ps-profile
	  (tramp-process-attributes-ps-args "-acxww" "-o" "pid,euid,user,egid,egroup,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state,ppid,pgid,sid,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etimes,pcpu,pmem,args")
	  (tramp-process-attributes-ps-format
	   (pid . number)
	   (euid . number)
	   (user . string)
	   (egid . number)
	   (group . string)
	   (comm . 52)
	   (state . string)
	   (ppid . number)
	   (pgrp . number)
	   (sess . number)
	   (ttname . string)
	   (tpgid . number)
	   (minflt . number)
	   (majflt . number)
	   (time . tramp-ps-time)
	   (pri . number)
	   (nice . number)
	   (vsize . number)
	   (rss . number)
	   (etime . number)
	   (pcpu . number)
	   (pmem . number)
	   (args)))
	 (tramp-connection-local-default-shell-profile
	  (shell-file-name . "/bin/sh")
	  (shell-command-switch . "-c"))
	 (tramp-connection-local-default-system-profile
	  (path-separator . ":")
	  (null-device . "/dev/null"))))
 '(custom-safe-themes
   '("6383295fb0c974d24c9dca1230c0489edf1cd5dd03d4b036aab290b6d3ceb50c" default))
 '(delete-selection-mode nil)
 '(elpy-rpc-python-command "python")
 '(fci-rule-color "#383838")
 '(inferior-R-args "--no-restore-history --no-save ")
 '(inhibit-startup-screen t)
 '(mark-even-if-inactive t)
 '(markdown-enable-math t)
 '(org-agenda-files
   '("~/git/orga/org/work.org" "~/git/orga/org/private.org" "~/git/orga/org/software.org" "~/git/orga/org/audio.org"))
 '(package-selected-packages
   '(ag helm-ag helm-company helm-flycheck helm-flymake helm-flyspell sr-speedbar tide yaml ess ess-smart-equals ess-smart-underscore docbook docbook-snippets rust-mode editorconfig irony 0blayout elpy pyvenv package-build shut-up epl git commander f dash s company-irony-c-headers helm-projectile golden-ratio stickyfunc-enhance function-args helm-gtags ggtags csound-mode yasnippet-snippets cmake-mode noxml-fold nxml-mode xml+ yaml-mode web-mode ts-comint scss-mode r-autoyas php-mode pdf-tools org2blog multi-web-mode meghanada magit lua-mode jinja2-mode jedi javascript javap-mode java-snippets hydra helm-youtube helm-swoop helm-bibtex helm-R go-mode elm-yasnippets elm-mode dockerfile-mode docker cask awk-it auctex))
 '(polymode-exporter-output-file-format "%s")
 '(scroll-bar-mode 'right)
 '(set-mark-command-repeat-pop t)
 '(transient-mark-mode 1)
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   '((20 . "#BC8383")
	 (40 . "#CC9393")
	 (60 . "#DFAF8F")
	 (80 . "#D0BF8F")
	 (100 . "#E0CF9F")
	 (120 . "#F0DFAF")
	 (140 . "#5F7F5F")
	 (160 . "#7F9F7F")
	 (180 . "#8FB28F")
	 (200 . "#9FC59F")
	 (220 . "#AFD8AF")
	 (240 . "#BFEBBF")
	 (260 . "#93E0E3")
	 (280 . "#6CA0A3")
	 (300 . "#7CB8BB")
	 (320 . "#8CD0D3")
	 (340 . "#94BFF3")
	 (360 . "#DC8CC3")))
 '(vc-annotate-very-old-color "#DC8CC3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Minimal mode. Removes some lines and bars from Emacs to make its
;; appearance more appealing
(require 'minimal)
(minimal-mode t)

;; Zenburn color scheme. Low contrast color scheme
(require 'zenburn)

;; Another Zenburn theme (from the git repository)
(add-to-list 'custom-theme-load-path
	     "~/git/configurations-and-scripts/emacs/.emacs.d/themes/")
(load-theme 'zenburn t)		       

;; Turn of blinking cursor (maybe the most important line in this file)
(blink-cursor-mode (- (*) (*) (*)))

;; Highlighting of matching paranthesis
(show-paren-mode t)

;; Edit the Emacs file at work in el mode
(add-to-list 'auto-mode-alist '(".emacs-tc08" . emacs-lisp-mode))

;; Arduino
(add-to-list 'auto-mode-alist '("\\.\\(pde\\|ino\\)$" . c++-mode))

;; Modifying markdown mode for correct displaying of German letters
(add-to-list 'load-path
	     "~/git/configurations-and-scripts/emacs/markdown-mode")
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(autoload 'gfm-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
;; GitHub Flavored Markdown-mode for all README.md files
;; (part of markdown-mode)
(add-to-list 'auto-mode-alist '("README.md" . gfm-mode))

;; Colors and human readable file size in dired
(setq dired-listing-switches "-alh")

;; Transparent background
;; (set-frame-parameter (selected-frame) 'alpha '(77 . 50))
;; (add-to-list 'default-frame-alist '(alpha . (77 . 50)))
(set-face-attribute 'default nil :background "black")

;; Use perl-mode for perl scripts
(add-to-list 'auto-mode-alist '("\\.plx" . perl-mode))
(add-to-list 'auto-mode-alist '("\\.pl" . perl-mode))

(add-to-list 'auto-mode-alist '("\\.json" . json-mode))

;; Use magit for handling the interaction with git
(global-set-key (kbd "C-x g") 'magit-status)
(setq magit-display-buffer-same-window-except-diff-v1 1)

;; Use iedit
(add-to-list 'load-path "~/git/configurations-and-scripts/emacs/iedit")
(require 'iedit)

;; Use Windmove in addition to my own keymap.
(require 'windmove)
(windmove-default-keybindings 'meta)

;; Loading and installing the lightning-keymap-mode keymap
(add-to-list
 'load-path
 "~/git/configurations-and-scripts/emacs/lightning-keymap-mode")
(require 'lightning-keymap-mode)
(lightning-keymap-mode 1)
;; Define a key to toggle the debugging of lightning-keymap-mode
(global-set-key (kbd "C-<f5>")
		(lambda()
		  (interactive)
		  (lightning-keymap-toggle-debugging)))

;; using conf-mode for frequently visited configuration scripts
(add-to-list 'auto-mode-alist '(".asoundrc" . conf-mode))
;; This one seems to cause some harm. Therefore I won't add it to the
;; front of the auto-most-alist but append it.
(add-to-list 'auto-mode-alist '("config\\([^\\.]\\)*" . conf-mode) t)
(add-to-list 'auto-mode-alist '("\\.conf" . conf-mode))
(add-to-list 'auto-mode-alist '("Dockerfile" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.in$" . conf-mode))
(add-to-list 'auto-mode-alist '("\\muttrc" . conf-mode))

;; Use shell-script-mode for linux configuration files
(add-to-list 'auto-mode-alist '("\\.xprofile*" . shell-script-mode))
(add-to-list 'auto-mode-alist '("\\.profile*" . shell-script-mode))
(add-to-list 'auto-mode-alist '("\\.xinitrc*" . shell-script-mode))
(add-to-list 'auto-mode-alist '("\\.bash*" . shell-script-mode))

;; Customize the grep command
;; ‘-i’   Ignore case distinctions
;; ‘-n’   Prefix each line of output with line number
;; ‘-H’   Print the filename for each match.
;; ‘-e’   Protect patterns beginning with a hyphen character, ‘-’ 
(setq grep-command "grep -i -nH -e ")

;; Easy evaluate lisp expressions even if `lightning-keymap-mode' is
;; activated. (Mapped to C-j in default Emacs).
(global-set-key (kbd "C-x e") 'eval-print-last-sexp)
(add-hook 'ess-mode-hook
	  (lambda()
	    (local-set-key (kbd "C-x e") 'eval-print-last-sexp)))

;; Use auto-fill-mode in various modes
(dolist (hook '(text-mode-hook
		LaTeX-mode-hook
		markdown-mode-hook
		fundamental-mode-hook
		lisp-interaction-mode-hook
		emacs-lisp-mode-hook
		ess-mode-hook
		c-mode-hook
		lua-mode-hook
		org-mode-hook) t)
  (add-hook hook (lambda() (auto-fill-mode 1))))

;; Load some custom functions to edit Hydrogen files
(load "~/git/configurations-and-scripts/emacs/elisp/hydrogen.el")
(add-to-list 'auto-mode-alist '("hydrogen.conf" . xml-mode))

;; Mute Emacs. Yes, there are devices playing a 'beep' received from Emacs.
(setq visible-bell 1)

;; Activate mutt mode
(require 'mutt)
;; Reducing global indentation width
(dolist (hook '(text-mode-hook
		fundamental-mode-hook
		lisp-interaction-mode-hook
		emacs-lisp-mode-hook
		go-mode-hook
		c++-mode-hook
		sh-mode-hook) t)
  (add-hook hook (lambda() (setq tab-width 4))))

;; Function to display ANSI escape colors in a log file
(require 'ansi-color)
(defun display-ansi-colors ()
  (interactive)
  (ansi-color-apply-on-region (point-min) (point-max)))

;; nXML
(setq nxml-slash-auto-complete-flag 1)
(add-to-list 'rng-schema-locating-files
			 "/usr/local/share/emacs/27.0.91/etc/schema/")
(push "~/.emacs.d/nxml-schemas/schemas.xml" rng-schema-locating-files-default)
(push (cons (concat "\\." (regexp-opt '("dbk" "docbook") t)
                    "\\'") 'nxml-mode) auto-mode-alist)
 
;; (load-file "~/git/configurations-and-scripts/emacs/elisp/po-mode.el")
;; (require 'po-mode)
;; (add-to-list 'auto-mode-alist '("\\.po" . po-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; TypeScript usage ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

;; redirect log into a file
(setq tide-tsserver-process-environment '("TSS_LOG=-level verbose -file /tmp/tss.log"));

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

(use-package tide
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))
