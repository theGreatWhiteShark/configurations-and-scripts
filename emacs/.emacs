;;;; Customization of the glorious Emacs
;; The screen of abyzou (my Acer laptop) is not that big. Use just two
;; spaces for indention
(setq standard-indent 2)
(setq tab-width 2)

;; loading personal scripts and functions 
(defvar elisp-path '("~/git/configurations-and-scripts/emacs/elisp/"))
(mapcar #'(lambda(p) (add-to-list 'load-path p)) elisp-path)

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
;; languages
(defun flyspell-switch-dictionary()
  (interactive)
  ;; Change the default dictionary too
  (if (string= ispell-current-dictionary "de")
      (setq ispell-personal-dictionary "~/.eamcs.d/.aspell.en.pws")
    (setq ispell-personal-dictionary "~/.eamcs.d/.aspell.de.pws"))
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
		org-mode-hook) t)
  (add-hook hook (lambda() (flyspell-mode 1))))
;; Activate Flyspell in the comments only.
(dolist (hook '(ess-mode-hook
		python-mode-hook
		web-mode-hook
		lisp-mode-hook
		emacs-lisp-mode-hook
		conf-mode-hook
		c-mode-hook) t)
  (add-hook hook (lambda() (flyspell-prog-mode))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;; using helm ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'helm)
(require 'helm-config)
;; remapping caps-lock to M-x
(if (eq window-system 'x)
    (shell-command "xmodmap -e 'clear Lock' -e 'keycode 66 = F13'"))
(global-set-key [f13] 'helm-M-x)
(global-unset-key (kbd "M-x"))
(global-set-key (kbd "M-x") 'helm-M-x)
(global-unset-key (kbd "C-x b"))
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-unset-key (kbd "C-x rb"))
(global-set-key (kbd "C-x rb") 'helm-bookmarks)
(global-unset-key (kbd "C-x C-f"))
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-s") 'helm-swoop)

;; Using TAB for completion within the helm seach
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;; ESS and R ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path
	     "~/git/configurations-and-scripts/emacs/ESS/lisp"
	     "~/git/configurations-and-scripts/emacs/ESS/etc")
(require 'ess-site)

;; Specify the export options of polymode to accelerate the export of
;; .Rmd files.
(add-hook 'ess-mode-hook
	  (lambda()
	    (defvar pm--exporter-hist "Rmarkdown")
	    (defvar pm--export:to-last "html document (html)")
	    (defvar pm--export:to-hist "html document (html)")))
;; using Rutils
(require 'ess-rutils)

;; Directory containing the binaries of the installed R version
(setq
 R-binary-folder "~/software/R/R-3.4.0/bin/"
 ;; A comment is a comment. No matter how many dashes
 ess-indent-with-fancy-comments nil
 ;; Try to complete statements
 ess-tab-complete-in-script 1
 ;; Use the GNU indentation style (2 whitespaces)
 ess-default-style 'GNU)
(defun myindent-ess-hook ()
  (setq ess-indent-level 2))
(add-hook 'ess-mode-hook 'myindent-ess-hook)
;; using the latest emacs version.
(setq
 inferior-R-program-name
 (concatenate 'string R-binary-folder "R")
 ;; AUCTeX interface for Sweave
 ess-swv-plug-into-AUCTeX-p t
 ;; activating polymode and bookdown-mode
 load-path
 (append
  '("~/git/configurations-and-scripts/emacs/polymode/"
    "~/git/configurations-and-scripts/emacs/polymode/modes"
    "~/git/configurations-and-scripts/emacs/bookdown-mode/")
  load-path))
(require 'bookdown-mode)
(require 'poly-R)
(require 'poly-bookdown)
(add-to-list 'auto-mode-alist '("\\.md" . poly-bookdown-mode))
(add-to-list 'auto-mode-alist '("\\.Snw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rnw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-bookdown+r-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;; Python ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; http://www.jesshamrick.com/2012/09/18/emacs-as-a-python-ide/
(add-to-list 'load-path
	     "~/git/configurations-and-scripts/emacs/python-mode")
(setq py-install-directory
      "~/git/configurations-and-scripts/emacs/python-mode")
(require 'python-mode)

;; If you want to use Python2.7 instead, you have to set the following
;; variable to "ipython" or use the py-choose-shell command before
;; executing code.
(setq-default py-shell-name "ipython3")
(setq-default py-which-bufname "IPython3")
;; use the wx backend for both mayavi and matplotlib
(setq
 py-python-command-args '("--gui=wx" "--pylab=wx" "-colors" "Linux" )
 py-force-py-shell-name-p t
 ;; don't split windows and don't change them either
 py-split-window-on-execute nil
 py-split-windows-on-execute nil
 py-split-windows-on-execute-p nil
 py-split-windows-on-execute-function nil
 ;; This one just won't work. 
 py-switch-buffers-on-execute-p t
 ;; such a pain in the ass
 py-keep-windows-configutation t
 ;; try to automagically figure out indentation
 py-smart-indentation nil
 ;; Use just two spaces for indention
 py-indent-offset 2
 ;; Use the TAB to call the py-indent-line function
 py-tab-indent t)
(add-hook 'python-mode-hook (lambda()
			      (setq tab-width 2)
			      (setq py-indent-offset 2)))

;; Use jedi for autocompletion
(add-hook 'python-mode-hook 'jedi:setup)
(setq
 jedi:complete-on-dot t
 ;; Use Python3 (Set up the virtual environment first outside of Emacs)
 jedi:environment-root "jedi")

;; load the python-mode for .bzl files since their Skylark language
;; resembles in some way the python syntax
(add-to-list 'auto-mode-alist '(".bzl$" . python-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;; web-mode ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Be consistent and use web-mode for all web development stuff
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . web-mode))
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
(require 'ox-html)
(require 'ox-latex)

(global-set-key "\C-ca" 'org-agenda)
(setq
 ;; My private files containing all different kinds of notes
 org-agenda-files (list
		   "~/git/tsa/org/work.org"
		   "~/git/tsa/org/private.org"
		   "~/git/tsa/org/software.org"
		   "~/git/tsa/org/notes/papers.org"
		   "~/git/tsa/org/notes/algorithms-computation.org")
 org-directory "~/git/tsa/org"
 ;; Add a time stamp whenever a TODO item is marked as DONE
 org-log-done "time"
 ;; A parent task can only be switched to DONE when all its
 ;; children tasks were accomplished.
 org-enforce-todo-dependencies t
 ;; Display the agenda in a slightly more compact format.
 org-agenda-compact-blocks t
 ;; Create an archive for each individual org file.
 org-archive-location "%s_archive::* Archived Tasks"
 ;; Don't ask for confirmation when evaluating code blocks in Org.
 org-confirm-babel-evaluate nil
 ;; Which R process to use when evaluating R code blocks. But I would
 ;; highly recommend to use ESS/polymode with Rmarkdown instead!
 org-babel-R-command (concatenate 'string R-binary-folder
				  "R --no-save --slave")
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
;; The custom class 'thesis' binds it all together.
(add-to-list 'org-latex-classes '("thesis"
				  "\\documentclass{article}
[NO-DEFAULT-PACKAGES]
[PACKAGES]
[EXTRA]"
                ("\\section{%s}" . "\\section*{%s}")
                ("\\subsection{%s}" "\\newpage" "\\subsection*{%s}" "\\newpage")
                ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                ("\\paragraph{%s}" . "\\paragraph*{%s}")
                ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; Use reftex to handle citations
(require 'reftex-cite)
(defun org-mode-reftex-setup ()
  (interactive)
  (and (buffer-file-name) (file-exists-p (buffer-file-name))
       (progn
	 ;; Reftex should use the org file as master file. See C-h v
	 ;;TeX-master for infos.
	 (setq TeX-master t)
	 (turn-on-reftex)
	 ;; enable auto-revert-mode to update reftex when bibtex file
	 ;; changes on disk
	 (global-auto-revert-mode t)
	 (reftex-parse-all)
	 ;; add a custom reftex cite format to insert links
	 ;; This also changes any call to org-citation!
	 (reftex-set-cite-format
	  '((?c . "\\citet{%l}") ; natbib inline text
	    (?i . "\\citep{%l}") ; natbib with parens
	    )))))
(add-hook 'org-mode-hook 'org-mode-reftex-setup)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; org-mode

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;; org-ref ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-ref for handling citations. Requires the hydra, parsebib,
;; helm, helm-bibtex package
(add-to-list 'load-path
	     "~/git/configurations-and-scripts/emacs/org-ref")
(require 'org-ref)

;; Local bibliography. This one is just available when the PKS home
;; is mounted.
(if (file-exists-p "~/phd/thesis/Bib_190917.bib")
    (setq
     org-ref-pdf-directory "~/pks_home/material/"
     bibtex-completion-library-path "~/pks_home/material/"
     ;; open the PDF using a PDF viewer
     bibtex-completion-pdf-open-function
     (lambda (fpath) (start-process "open" "*open*" "open" fpath))))
;; Assuring correct LaTeX exportation of org-ref commands
(setq 
 reftex-default-bibliography '("~/phd/thesis/Bib_190917.bib")
 org-ref-default-bibliography '("~/phd/thesis/Bib_190917.bib")
 bibtex-completion-bibliography "~/phd/thesis/Bib_190917.bib"
 org-latex-pdf-process
 '("pdflatex -interaction nonstopmode -output-directory %o %f"
   "bibtex %b"
   "pdflatex -interaction nonstopmode -output-directory %o %f"
   "pdflatex -interaction nonstopmode -output-directory %o %f"))
;; Helpful tools for retrieving bibtex entries
(require 'doi-utils)
(require 'org-ref-isbn)
(require 'org-ref-arxiv)
(require 'org-ref-pdf) ;; allows drag and drop of PDFs
(require 'org-ref-url-utils) ;; drag and drop from the web browser

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
(setq yas-snippet-dirs
      '("~/git/configurations-and-scripts/emacs/yasnippet/snippets"
	"~/git/configurations-and-scripts/emacs/yasnippet/yasmate/snippets"))
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

;; Show line numbers
(autoload 'linum-mode "linum" "toggle line numbers on/off" t)
(global-set-key (kbd "C-<f5>") 'linum-mode)

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

;; Using 'ibuffer' to group buffer. This becomes handy when there is
;; a large amount of them.
(require 'ibuffer)
(setq ibuffer-saved-filter-groups
      '(("default"
	 ("Org"
	  (mode . org-mode))
	 ("Git"
	  (filename . "~/git/"))
	 ("Phd"
	  (filename . "~/phd/"))
	 ("Configuration"
	  (or
	   (filename . "~/git/configurations-and-scripts/")
	   (mode . conf-mode)))
	 ("Emacs"
	  (mode . emacs-lisp-mode))
	 ("Interpreter"
	  (or
	   (name . "^\\*terminal*")
	   (name . "\\*ESS*")))
	 ("Programming"
	  (or
	   (mode . ess-mode)
	   (mode . LaTeX-mode)
	   (mode . c-mode)
	   (mode . lua-mode)
	   (mode . python-mode)
	   (mode . sh-mode)
	   (mode . awk-mode))))))
(add-hook 'ibuffer-mode-hook
	  (lambda() (ibuffer-switch-to-saved-filter-groups "default")))
(global-set-key (kbd "C-x C-b") 'ibuffer)

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

;; Using multi-term to open more than one terminal in emacs
(autoload 'multi-term "multi-term" nil t)
(autoload 'multi-term-next "multi-term" nil t)
(setq multi-term-program "/bin/bash")
(global-set-key (kbd "C-c t") 'multi-term-next)
(global-set-key (kbd "C-c T") 'multi-term)

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
   ["#3F3F3F" "#CC93932" "#7F9F7F" "#F0DFAF" "#8CD0D3" "#DC8CC3"
    "#93E0E3" "#DCDCCC"])
 '(custom-safe-themes
   (quote
    ("6383295fb0c974d24c9dca1230c0489edf1cd5dd03d4b036aab290b6d3ceb50c" default)))
 '(delete-selection-mode nil)
 '(fci-rule-color "#383838")
 '(inhibit-startup-screen t)
 '(mark-even-if-inactive t)
 '(org-agenda-files
   (quote
    ("~/git/tsa/org/work.org" "~/git/tsa/org/private.org"
     "~/git/tsa/org/software.org")))
 '(polymode-exporter-output-file-format "%s")
 '(scroll-bar-mode (quote right))
 '(transient-mark-mode 1)
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
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
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-M-x-key ((t (:foreground "#CC9393"))))
 '(helm-ff-directory ((t (:foreground "#93E0E3" :weight bold
				      :background nil))))
 '(helm-ff-dotted-directory ((t (:foreground "steel blue"
					     :background nil))))
 '(helm-ff-dotted-symlink-directory ((t (:foreground "DarkOrange"
						     :background nil))))
 '(helm-ff-executable ((t (:foreground "#9FC59F" :weight normal
				       :background nil))))
 '(helm-ff-file ((t (:foreground "#DCDCCC" :weight normal
				 :background nil))))
 '(helm-ff-invalid-symlink ((t (:foreground "#CC9393" :weight bold
					    :background nil))))
 '(helm-ff-prefix ((t (:foreground "#3F3F3F" :weight normal
				   :background nil))))
 '(helm-ff-symlink ((t (:foreground "#F0DFAF" :weight bold
				    :background nil))))
 '(helm-match ((t (:foreground "khaki" :underline t))))
 '(helm-match-item ((t (:foreground "khaki")))))

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



;; Activating c-mode for CUDA files
(setq auto-mode-alist (cons '(".cu$" . c-mode) auto-mode-alist))

;; Arduino
(add-to-list 'load-path
	     "~/git/configurations-and-scripts/emacs/arduino-mode")
(add-to-list 'auto-mode-alist '("\\.\\(pde\\|ino\\)$" . arduino-mode))
(autoload 'arduino-mode "arduino-mode" nil t)

;; Why is the marking of regions not working with i3 on behemoth?
(global-set-key (kbd "M-SPC") 'set-mark-command)

;; Modifying markdown mode for correct displaying of German letters
(add-to-list 'load-path
	     "~/git/configurations-and-scripts/emacs/markdown-mode")
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Colors and human readable file size in dired
(setq dired-listing-switches "-alh")

;; Transparent background
(set-frame-parameter (selected-frame) 'alpha '(77 . 50))
(add-to-list 'default-frame-alist '(alpha . (77 . 50)))
(set-face-attribute 'default nil :background "black")

;; Use perl-mode for perl scripts
(add-to-list 'auto-mode-alist '("\\.plx" . perl-mode))
(add-to-list 'auto-mode-alist '("\\.pl" . perl-mode))

;; Use magit for handling the interaction with git
(global-set-key (kbd "C-x g") 'magit-status)

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

;; using conf-mode for frequently visited configuration scripts
(add-to-list 'auto-mode-alist '(".asoundrc" . conf-mode))
;; This one seems to cause some harm. Therefore I won't add it to the
;; front of the auto-most-alist but append it.
(add-to-list 'auto-mode-alist '("config\\([^\\.]\\)*" . conf-mode) t)
(add-to-list 'auto-mode-alist '("\\.conf" . conf-mode))

;; Customize the grep command
;; ‘-i’   Ignore case distinctions
;; ‘-n’   Prefix each line of output with line number
;; ‘-H’   Print the filename for each match.
;; ‘-e’   Protect patterns beginning with a hyphen character, ‘-’ 
(setq grep-command "grep -i -nH -e ")

;; GitHub Flavored Markdown-mode for all README.md files
;; (part of markdown-mode)
(add-to-list 'auto-mode-alist '("README.md" . gfm-mode))

;; Open dired, even when I'm typing C-x C-d by mistake
(global-set-key (kbd "C-x C-d") 'dired)
