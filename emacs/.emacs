;; Customization of the glorious Emacs
;; The screen of abyzou (my Acer laptop) is not that big. Use just two
;; spaces for indention
(setq standard-indent 2)
(setq tab-width 2)

;; loading personal scripts and functions from ~elisp
(defvar elisp-path '("~/git/configurations-and-scripts/emacs/elisp/"))
(mapcar #'(lambda(p) (add-to-list 'load-path p)) elisp-path)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;; spell checking ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Activate on the fly spellchecking for all major modes I use on a
;; regular basis
(load-file "~/git/configurations-and-scripts/emacs/elisp/flyspell.el")
(require 'flyspell2)
(add-hook 'text-mode-hook (lambda() (flyspell-mode 1)))
(add-hook 'LaTeX-mode-hook (lambda() (flyspell-mode 1)))
(add-hook 'markdown-mode-hook (lambda() (flyspell-mode 1)))
(add-hook 'org-mode-hook (lambda() (flyspell-mode 1)))
(add-hook 'ess-mode-hook (lambda() (flyspell-prog-mode)))
(add-hook 'python-mode-hook (lambda() (flyspell-prog-mode)))
(add-hook 'web-mode-hook (lambda() (flyspell-prog-mode)))
(add-hook 'emacs-lisp-mode-hook (lambda() (flyspell-prog-mode)))
(add-hook 'lisp-mode-hook (lambda() (flyspell-prog-mode)))
(add-hook 'c-mode-hook (lambda() (flyspell-prog-mode)))
(add-hook 'conf-mode-hook (lambda() (flyspell-prog-mode)))

;; The default dictionary to be used should be the English one
(setq flyspell-default-dictionary "en")
;; Use a central personal dictionary. (Via a symbolic link from the
;; git repository)
;; The personal dictionary has always to be of the same language as the
;; current used one!
(setq ispell-personal-dictionary "~/.emacs.d/.aspell.en.pws")

;; Increase the speed (since we are using the more slower aspell instead
;; of ispell)
(setq ispell-extra-args '("--sug-mode=fast"))

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ESS and R
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
(add-to-list 'load-path "~/git/configurations-and-scripts/emacs/ESS/lisp" "~/git/configurations-and-scripts/emacs/ESS/etc")
(load "ess-site")
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
(setq R-binary-folder "/home/phil/software/R/R-3.4.0/bin/")

;; A comment is a comment. No matter how many dashes
(setq ess-indent-with-fancy-comments nil)

;; Try to complete statements
(setq ess-tab-complete-in-script 1)

;; Use the GNU indentation style (2 whitespaces)
(setq ess-default-style 'GNU)
(defun myindent-ess-hook ()
  (setq ess-indent-level 2))
(add-hook 'ess-mode-hook 'myindent-ess-hook)
;; using the latest emacs version.
(setq inferior-R-program-name
      (concatenate 'string R-binary-folder "R"))

;; AUCTeX interface for Sweave
(setq ess-swv-plug-into-AUCTeX-p t)

;; activating polymode
(setq load-path
      (append '("~/git/configurations-and-scripts/emacs/polymode/" "~/git/configurations-and-scripts/emacs/polymode/modes")
	      load-path))
(require 'poly-R)
(require 'poly-markdown)
(add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
(add-to-list 'auto-mode-alist '("\\.Snw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rnw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq load-path (cons "~/git/configurations-and-scripts/emacs/org-mode/lisp" load-path))
(setq load-path (cons "~/git/configurations-and-scripts/emacs/org-mode/contrib/lisp" load-path))
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
;; use syntax highlighting
(add-hook 'org-mode-hook 'turn-on-font-lock)
(require 'org)

(global-set-key "\C-ca" 'org-agenda)
;; Displayes the closed date whenever a TODO is marked as DONE
(setq org-log-done t)
;; My private files containing all different kinds of notes
(setq org-agenda-files (list "~/git/tsa/org/work.org"
			     "~/git/tsa/org/interest.org"
			     "~/git/tsa/org/private.org"
			     "~/git/tsa/org/software.org"
			     "~/git/tsa/org/notes/papers.org"
			     "~/git/tsa/org/notes/algorithms-computation.org"))

(setq 
 org-directory "~/git/tsa/org"
 org-outline-path-complete-in-steps nil
 org-indirect-buffer-display 'current-window
 )

;; customize agenda view
(setq
 org-agenda-dim-blocked-tasks nil
 org-agenda-compact-blocks t
 org-agenda-custom-commands
 (quote (("N" "Notes" tags "NOTE"
	  ((org-agenda-overriding-header "Notes")
	   (org-tags-match-list-sublevels t)))
	 (" " "Agenda"
	  ((agenda "" nil)
	   (tags "REFILE"
		 ((org-agenda-overriding-header "Tasks to Refile")
		  (org-tags-match-list-sublevels nil)))
	   nil))))
 )

;; I havn't actually yet looked into this one (copied it from a blog
;; some years ago). During a sleepless night I might have a look at it.
;; archive setup
(setq org-archive-mark-done nil)
(setq org-archive-location "%s_archive::* Archived Tasks")
(defun foreign-skip-non-archivable-tasks ()
  "Skip trees that are not available for archiving"
  (save-restriction
    (widen)
    ;; consider only tasks with done todo headings
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max))))
	  (subtree-end (save-excursion (org-end-of-subtree t))))
      (if (member (org-get-todo-state) org-todo-keywords-1)
	  (if (member (org-get-todo-state) org-done-keywords)
	      (let* ((daynr (string-to-int (format-time-string "%d" (current-time))))
		     (a-month-ago (* 60 60 24 (+ daynr 1)))
		     (last-month (format-time-string "%Y-%m-" (time-subtract (current-time) (seconds-to-time a-month-ago))))
		     (this-month (format-time-string "%Y-%m-" (current-time)))
		     (subtree-is-current (save-excursion
					   (forward-line 1)
					   (and (< (point) subtree-end)
						(re-search-forward (concat last-month "\\|" this-month) subtree-end t)))))
		(if subtree-is-current
		    subtree-end ; has a date in this or last month, skip it
		  nil)) ; archive
	    (or subtree-end (point-max)))
	next-headline))))

;; exporting
(setq org-alphabetical-lists t)
(require 'ox-html)
(require 'ox-latex)

(defun foreign-display-inline-images ()
  (condition-case nil
      (org-display-inline-images)
    (error nil)))
(add-hook 'org-babel-after-execute-hook 'foreign-display-inline-images 'append)
(setq
 org-confirm-babel-evaluate nil
 org-startup-with-inline-images nil ; cause it breaks when accessing via ssh
 org-babel-R-command (concatenate 'string R-binary-folder "R --no-save --slave")
 )
(org-babel-do-load-languages
 (quote org-babel-load-languages)
 (quote ((emacs-lisp . t)
	 (R . t)
	 (python . t)
	 (sh . t)
	 (org . t)
	 (latex . t))))

;; Create a custom LaTeX class for my PhD thesis in order to
;; export it to LaTeX with the minimal pain in the ass.
;; see http://www.draketo.de/english/emacs/writing-papers-in-org-mode-acpd
;; (require 'org-latex)
(setq org-latex-packages-alist (quote (("" "color" t)
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
				       ("" "url" t)))
      org-latex-pdf-process
      (quote ( "pdflatex -interaction nonstopmode -shell-escape -output-directory latex/%o latex/%f"
	       "bibtex latex/$basename %b)"
	       "pdflatex -interaction nonstopmode -shell-escape -output-directory latex/%o latex/%f"
	       "bibtex latex/$basename %b)"
	       "pdflatex -interaction nonstopmode -shell-escape -output-directory latex/%o latex/%f")))
(add-to-list 'org-latex-classes
	     `("thesis"
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
        ; Reftex should use the org file as master file. See C-h v TeX-master for infos.
        (setq TeX-master t)
        (turn-on-reftex)
        ; enable auto-revert-mode to update reftex when bibtex file changes on disk
        (global-auto-revert-mode t) ; careful: this can kill the undo
                                    ; history when you change the file
                                    ; on-disk.
        (reftex-parse-all)
        ; add a custom reftex cite format to insert links
        ; This also changes any call to org-citation!
        (reftex-set-cite-format
         '((?c . "\\citet{%l}") ; natbib inline text
           (?i . "\\citep{%l}") ; natbib with parens
           ))))
  (define-key org-mode-map (kbd "C-c )") 'reftex-citation)
  (define-key org-mode-map (kbd "C-c (") 'org-mode-reftex-search))

(add-hook 'org-mode-hook 'org-mode-reftex-setup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; org-mode
;; yasnippet
(load-file "~/git/configurations-and-scripts/emacs/yasnippet/yasnippet.el")
(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/git/configurations-and-scripts/emacs/yasnippet/snippets"
	"~/git/configurations-and-scripts/emacs/yasnippet/yasmate/snippets"))
(yas-global-mode 1)

;; but the prevents tab expansion in the terminal, so:
(add-hook 'term-mode-hook (lambda()
			    (setq yas-dont-activate t)))
(add-hook 'ess-mode-hook
	  (lambda() (yas-minor-mode 1)))
(add-hook 'LaTeX-mode-hook
	  (lambda() (yas-minor-mode 1)))
(add-hook 'LaTeX-mode-hook
	  (lambda() (local-set-key [tab] 'yas/expand)))
(add-hook 'Rnw-mode-hook
	  (lambda() (yas-minor-mode 1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;; diverse ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; enable time stamp and automatic time stamp when saving data
(setq
 time-stamp-active t
 time-stamp-lin-limit 10 ; check first 10 buffer lines for Time-stamp
 time-stamp-format "%04y-%02m-%02d %02H:%02M:%02S (%u)")
(add-hook 'write-file-hooks 'time-stamp); update when saving

;; show line numbers ;; höhö, never actually used this one. But it's nice
(autoload 'linum-mode "linum" "toggle line numbers on/off" t)
(global-set-key (kbd "C-<f5>") 'linum-mode)
(add-hook 'ess-mode-hook
	  (lambda() 'linum-mode 1))

;; Provides the general editor behavior in Emacs:
;; Highlighting a region and deleting it with DEL or just replace the
;; text by typing in a different one.
(delete-selection-mode t)

;; cycling through your buffers with Ctrl-Tab
(global-set-key (kbd "<C-tab>") 'bury-buffer)

;; easier switchting between buffers (with alt key)
(require 'windmove)
(windmove-default-keybindings 'meta)

;; enable rectangle marking
(require 'rect-mark)

;; ;; viewing register contents
(require 'list-register)
(global-set-key (kbd "C-x r v") 'list-register)

;; highlight changes in files under version control
(global-highlight-changes-mode t)
(setq highlight-changes-visibility-initial-state nil); initially hidden
(global-set-key (kbd "<f6>") 'highlight-changes-visible-mode) ;; toggle visibility
(global-set-key (kbd "S-<f6>") 'highlight-changes-remove-highlight)
(set-face-foreground 'highlight-changes nil)
(set-face-background 'highlight-changes "#382f2f")
(set-face-foreground 'highlight-changes-delete nil)
(set-face-background 'highlight-changes-delete "#916868")
(put 'downcase-region 'disabled nil)

;; more sophisticated use of the killring
(when (require 'browse-kill-ring nil 'noerror)
  (browse-kill-ring-default-keybindings))
(global-set-key "\C-cy" '(lambda ()
			   (interactive)
			   (popup-menu 'yank-menu)))

;; change cursor color
(defun foreign-set-cursor-according-to-mode ()
  "change cursor color to red if overwrite is activated"
  (cond 
   (overwrite-mode
    (set-cursor-color "red")
    (setq cursor-type 'box))
   (t
    (set-cursor-color "#dcdccc")
    (setq cursor-type 'box))))
(add-hook 'post-command-hook 'foreign-set-cursor-according-to-mode)

;; making buffer names unique
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward
      uniquify-separatir ":")

;; if nothing is selected assume I meant the current line
(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive 
   (if mark-active (list (region-beginning) (region-end))
     (message "Copied line")
     (list (line-beginning-position) 
	   (line-beginning-position 2)))))
(defadvice kill-region (before slick-cut activate compile)
  "When calles interactively with no active region, kill a single line instead."
  (interactive 
   (if mark-active (list (region-beginning) (region-end))
     (message "Cut line")
     (list (line-beginning-position)
	   (line-beginning-position 2)))))

;; autosave changes in the bookmarks
(setq bookmark-save-flag 1)

;; useing ibuffer to group buffer and deal with them when there is really a large amount of them
(require 'ibuffer)
(setq ibuffer-saved-filter-groups
      (quote (("default"
	       ("Org"
		(mode . org-mode))
	       ("Calculations"
		(filename . "~/calculations/"))
	       ("Work"
		(filename . "~/work/"))
	       ("Configuration"
		(or
		 (filename . "~/git/configurations-and-scripts/")
		 (mode . emacs-lisp-mode)))
	       ("Programming"
		(or
		 (mode . ess-mode)
		 (mode . LaTeX-mode)
		 (mode . c-mode)
		 (mode . lua-mode)
		 (mode . python-mode)
		 (mode . sh-mode)
		 (mode . awk-mode)))))))
(add-hook 'ibuffer-mode-hook
	  (lambda() (ibuffer-switch-to-saved-filter-groups "default")))
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; interactive editing
(add-to-list 'load-path "~/git/configurations-and-scripts/emacs/iedit")
(require 'iedit)
(define-key global-map (kbd "C-\\") 'iedit-mode)
(global-set-key (kbd "C-|") 'replace-string)
(define-key ess-mode-map (kbd "C-\\") 'iedit-mode)

;; shortens the content of the mode line
(when (require 'diminish nil 'noerror)
  (eval-after-load "company"
    '(diminish 'company-mode "Cmp"))
  (eval-after-load "yasnippet"
    '(diminish 'yas-minor-mode " Y")))
(add-hook 'emacs-lisp-mode-hook 
	  (lambda() (setq mode-name "el")))

;; kills buffers which are more than 3 days untouched
(require 'midnight)

;; colorful delimiters 
(require 'rainbow-delimiters)
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
(add-hook 'ess-mode-hook 'rainbow-delimiters-mode)
(add-hook 'lisp-mode-hook 'rainbow-delimiters-mode)
(add-hook 'python-mode-hook 'rainbow-delimiters-mode)
(rainbow-delimiters-mode 1)

;; using multi-term to open more than one terminal in emacs
(autoload 'multi-term "multi-term" nil t)
(autoload 'multi-term-next "multi-term" nil t)
(setq multi-term-program "/bin/bash")
(global-set-key (kbd "C-c t") 'multi-term-next)
(global-set-key (kbd "C-c T") 'multi-term)

;; changing the style of the mode-line
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
				   (concat (format-time-string "%c; ") (emacs-uptime "Uptime: %hh"))))
	       " --"
	       ;; minor modes
	       minor-mode-alist
	       ))
;; setting of the term colors. Unfortunately this is necessary since using Emacs 24.3 and the zenburn theme
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
			  [term term-color-black term-color-red term-color-green term-color-yellow 
				term-color-blue term-color-magenta term-color-cyan term-color-white])
	    (put 'narrow-to-region 'disabled nil)))	    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;; diverse
;; source the .emacs file after alteration while still running an active emacs session
(defun reload ()
  (interactive)
  (load-file "~/.emacs"))

;; dismissing the startup screen
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#3F3F3F" "#CC93932" "#7F9F7F" "#F0DFAF" "#8CD0D3" "#DC8CC3" "#93E0E3" "#DCDCCC"])
 '(custom-safe-themes
   (quote
    ("6383295fb0c974d24c9dca1230c0489edf1cd5dd03d4b036aab290b6d3ceb50c" default)))
 '(delete-selection-mode nil)
 '(fci-rule-color "#383838")
 '(inhibit-startup-screen t)
 '(mark-even-if-inactive t)
 '(org-agenda-files
   (quote
    ("~/git/tsa/org/work.org" "~/git/tsa/org/private.org" "~/git/tsa/org/software.org" "~/git/tsa/org/refile.org")))
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

;; Minimal mode. Removes some lines and bars from Emacs to make its appearance more appealing
(require 'minimal)
(minimal-mode t)

;; Zenburn color scheme. Low contrast color scheme
(require 'zenburn)

;; Another Zenburn theme (from the git repository)
(add-to-list 'custom-theme-load-path "~/git/configurations-and-scripts/emacs/.emacs.d/themes/")
(load-theme 'zenburn t)		       

;; Accessing the command history more easy
(eval-after-load "comint"
  '(progn
     (define-key comint-mode-map [up]
       'comint-previous-matching-input-from-input)
     (define-key comint-mode-map [down]
       'comint-next-matching-input-from-input)
     (setq comint-scroll-to-botoom-on-output 'others)
     (setq comint-scroll-show-maximum-output t)
     (setq comint-scroll-to-bottom-on-input 'this)
     ))

;; turn of blinking cursor
(blink-cursor-mode (- (*) (*) (*)))

;; highlighting of matching paranthesis
(show-paren-mode t)

;; configuring default printer
(setq printer-name "ps6")

;; Edit the Emacs file at work in el mode
(setq auto-mode-alist (cons '(".emacs-tc08" . emacs-lisp-mode) auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; http://www.jesshamrick.com/2012/09/18/emacs-as-a-python-ide/
(add-to-list 'load-path "~/git/configurations-and-scripts/emacs/python-mode")
(setq py-install-directory "~/git/configurations-and-scripts/emacs/python-mode")
(require 'python-mode)

;; If you want to use Python2.7 instead, you have to set the following
;; variable to "ipython" or use the py-choose-shell command before
;; executing code.
(setq-default py-shell-name "ipython3")
(setq-default py-which-bufname "IPython3")
;; use the wx backend for both mayavi and matplotlib
(setq py-python-command-args '("--gui=wx" "--pylab=wx" "-colors" "Linux" ))
(setq py-force-py-shell-name-p t)

;; don't split windows and don't change them either
(setq py-split-window-on-execute nil)
(setq py-split-windows-on-execute nil)
(setq py-split-windows-on-execute-p nil)
(setq py-split-windows-on-execute-function nil)
;; This one just won't work. 
(setq py-switch-buffers-on-execute-p t)
;; such a pain in the ass
(setq py-keep-windows-configutation t)
;; try to automagically figure out indentation
(setq py-smart-indentation nil)
;; Use just two spaces for indention
(setq py-indent-offset 2)
(add-hook 'python-mode-hook (lambda()
			      (setq tab-width 2)
			      (setq py-indent-offset 2)))
;; Use the TAB to call the py-indent-line function
(setq py-tab-indent t)

;; Use jedi for autocompletion
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
;; Use Python3 (Set up the virtual environment first outside of Emacs)
(setq jedi:environment-root "jedi")

;; load the python-mode for .bzl files since their Skylark language
;; resembles in some way the python syntax
(setq auto-mode-alist (cons '(".bzl$" . python-mode) auto-mode-alist))
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; using the MELPA repository
(require 'package)
;; more packages
(setq package-archives '(("ELPA" . "http://tromey.com/elpa/")
			 ("gnu" . "http://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ;; seems not to work right now
			 ))
(package-initialize)

;; activating c-mode for CUDA files
(setq auto-mode-alist (cons '(".cu$" . c-mode) auto-mode-alist))


;; Arduino
(add-to-list 'load-path "~/git/configurations-and-scripts/emacs/arduino-mode")
(setq auto-mode-alist (cons '("\\.\\(pde\\|ino\\)$" . arduino-mode) auto-mode-alist))
(autoload 'arduino-mode "arduino-mode" nil t)

;; Why is the marking of regions not working with i3 on behemoth?
(global-set-key (kbd "M-SPC") 'set-mark-command)

;; Modifying markdown mode for correct displaying of German letters
(add-to-list 'load-path "~/git/configurations-and-scripts/emacs/markdown-mode")
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; colors and human readable file size in dired
(setq dired-listing-switches "-alh")

;; transparent background
(set-frame-parameter (selected-frame) 'alpha '(77 . 50))
(add-to-list 'default-frame-alist '(alpha . (77 . 50)))

(set-face-attribute 'default nil :background "black")

;; use perl-mode for perl scripts
(add-to-list 'auto-mode-alist '("\\.plx" . perl-mode))
(add-to-list 'auto-mode-alist '("\\.pl" . perl-mode))

;; wdired: using C-x C-q the dired buffer becomes editable. Nice!
;; Use magit for handling the interaction with git
(global-set-key (kbd "C-x g") 'magit-status)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; org-ref ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-ref for handling citations. Requires the hydra, parsebib,
;; helm, helm-bibtex package
(add-to-list 'load-path "~/git/configurations-and-scripts/emacs/org-ref")
(require 'org-ref)

;; Local bibliography. This one is just available when the PKS home
;; is mounted.
(if (file-exists-p "~/pks_home/material/collection.bib")
    (setq reftex-default-bibliography '("~/pks_home/material/collection.bib")
	  org-ref-default-bibliography '("~/pks_home/material/collection.bib")
	  bibtex-completion-bibliography "~/pks_home/material/collection.bib"
	  org-ref-pdf-directory "~/pks_home/material/"
	  bibtex-completion-library-path "~/pks_home/material/"
	  ;; open the PDF using a PDF viewer
	  bibtex-completion-pdf-open-function
	  (lambda (fpath) (start-process "open" "*open*" "open" fpath))))
;; Assuring correct LaTeX exportation of org-ref commands
(setq org-latex-pdf-process
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;; using helm ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'helm)
(require 'helm-config)
;; remapping caps-lock to M-x
(if (eq window-system 'x)
    (shell-command "xmodmap -e 'clear Lock' -e 'keycode 66 = F13'"))
(global-set-key [f13] 'helm-M-x)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "C-x rb") 'helm-bookmarks)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-s") 'helm-swoop)

;; Using TAB for completion within the helm seach
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)

;; Customized keybindings for navigation, killing and various other
;; useful things.
;; In order to not consider any special cases and to not get annoyed by
;; minor-mode key maps (especially flyspell), I will define my own
;; minor-mode which enforces my custom key bindings on all the major
;; modes. Whenever I want to switch back to the original key bindings,
;; I just disable this minor-mode.
(defvar custom-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))
    ;; Navigation
    (define-key map (kbd "M-S backspace") 'kill-sentence)
    (define-key map (kbd "M-S-j") 'windmove-left)
    (define-key map (kbd "M-J") 'windmove-left)
    (define-key map (kbd "M-S-k") 'windmove-up)
    (define-key map (kbd "M-K") 'windmove-up)
    (define-key map (kbd "M-S-l") 'windmove-down)
    (define-key map (kbd "M-L") 'windmove-down)
    (define-key map (kbd "M-S-;") 'windmove-right)
    (define-key map (kbd "M-:") 'windmove-right)
    (define-key map (kbd "C-j") 'left-char)
    (define-key map (kbd "C-l") 'next-line)
    (define-key map (kbd "C-k") 'previous-line)
    (define-key map (kbd "C-;") 'right-char)
    ;; For faster scrolling
    (define-key map (kbd "C-S-j") (lambda()
				    (interactive)
				    (setq count 0)
				    (while (< count 5)
				      (left-char)
				      (setq count (+ count 1)))))
    (define-key map (kbd "C-:") (lambda()
				    (interactive)
				    (setq count 0)
				    (while (< count 5)
				      (right-char)
				      (setq count (+ count 1)))))
    (define-key map (kbd "C-S-k") (lambda()
				    (interactive)
				    (setq count 0)
				    (while (< count 15)
				      (previous-line)
				      (setq count (+ count 1)))))
    (define-key map (kbd "C-S-l") (lambda()
				    (interactive)
				    (setq count 0)
				    (while (< count 15)
				      (next-line)
				      (setq count (+ count 1)))))
    ;; For even fast scrolling
    (define-key map (kbd "C-M-S-j") (lambda()
				    (interactive)
				    (setq count 0)
				    (while (< count 15)
				      (left-char)
				      (setq count (+ count 1)))))
    (define-key map (kbd "C-M-:") (lambda()
				    (interactive)
				    (setq count 0)
				    (while (< count 15)
				      (right-char)
				      (setq count (+ count 1)))))
    (define-key map (kbd "C-M-S-k") 'backward-page)
    (define-key map (kbd "C-M-S-l") 'forward-page)
    ;; For jumping between words and paragraphs
    (define-key map (kbd "M-j") 'left-word)
    (define-key map (kbd "M-l") 'forward-paragraph)
    (define-key map (kbd "M-k") 'backward-paragraph)
    (define-key map (kbd "M-;") 'right-word)
    ;; For jumping through the whole document
    (define-key map (kbd "C-M-j") 'move-beginning-of-line)
    (define-key map (kbd "C-M-k") 'beginning-of-buffer)
    (define-key map (kbd "C-M-l") 'end-of-buffer)
    (define-key map (kbd "C-M-;") 'move-end-of-line)
    ;; Killing
    (define-key map (kbd "C-,") 'backward-delete-char-untabify)
    (define-key map (kbd "C-.") 'delete-forward-char)
    (define-key map (kbd "M-,") (lambda()
				  (interactive)
				  (if mark-active
				      (kill-region
				       (region-beginning)
				       (region-end))
				    (backward-kill-word 1))))
    (define-key map (kbd "M-.") (lambda()
				  (interactive)
				  (if mark-active
				      (kill-region
				       (region-beginning)
				       (region-end))
				    (kill-word 1))))
    (define-key map (kbd "C-M-.") 'kill-line)
    (define-key map (kbd "C-M-,") 'kill-whole-line)
    ;; Copying (it's not that convenient to have the copying and yanking
    ;; in a row different than the one used for killing. But in order
    ;; to avoid conflicts with the C-n behavior of the terminal I will
    ;; go with this setting for now.
    ;; (copy word, copy line, copy paragraph)
    (define-key map (kbd "C-p") (lambda()
				  (interactive)
				  (left-word)
				  (mark-word)
				  (copy-region-as-kill
				   (region-beginning)
				   (region-end))))
    (define-key map (kbd "M-p") (lambda()
				  (interactive)
				  (if mark-active
				      (copy-region-as-kill
				       (region-beginning)
				       (region-end))
				    (copy-region-as-kill
				     (line-beginning-position)
				     (line-end-position)))))
    (define-key map (kbd "C-M-p") (lambda()
				    (interactive)
				    (backward-paragraph)
				    (mark-paragraph)
				    (copy-region-as-kill
				     (region-beginning)
				     (region-end))))
    ;; Yanking (at point, newline and yank, yank in previous line)
    (define-key map (kbd "C-o") 'yank)
    (define-key map (kbd "M-o") (lambda()
				  (interactive)
				  (move-end-of-line 1)
				  (newline-and-indent)
				  (yank)))
    (define-key map (kbd "C-M-o") 'helm-show-kill-ring)
    ;; Commenting (insert comment, comment line, paragraph)
    (define-key map (kbd "C-'") (lambda()
				  (interactive)
				  (insert comment-start)
				  (insert "  ")
				  (insert comment-end)
				  (left-char
				   (+ (string-width comment-end) 1))))
    (define-key map (kbd "M-'") (lambda()
				  (interactive)
				  (if mark-active
				      (comment-or-uncomment-region
				       (region-beginning)
				       (region-end))
				    (comment-or-uncomment-region
				     (line-beginning-position)
				     (line-end-position)))))

    (define-key map (kbd "C-M-'") (lambda()
				    (interactive)
				    (backward-paragraph)
				    (mark-paragraph)
				    (comment-or-uncomment-region
				     (region-beginning)
				     (region-end))))
    ;; Indenting( line, paragraph, buffer )
    ;; Don't bind this or the TAB won't work anymore
    ;; (define-key map (kbd "C-i") 'indent-region)
    (define-key map (kbd "M-i") (lambda()
				  (interactive)
				  (if mark-active
				      (indent-region
				       (region-beginning)
				       (region-end))
				    (progn
				      (backward-paragraph)
				      (mark-paragraph)
				      (indent-region
				       (region-beginning)
				       (region-end))))))
    (define-key map (kbd "C-M-i") (lambda ()
				    (interactive)
				    (mark-whole-buffer)
				    (indent-region
				     (region-beginning)
				     (region-end))))
    ;; Rectangle marking, cutting, pasting
    (define-key map (kbd "C-u") 'rm-set-mark)
    (define-key map (kbd "M-u") 'rm-kill-region)
    (define-key map (kbd "C-M-u") 'rm-kill-ring-save)
    ;; Binding something to Ctrl-m causes problems because Emacs does not
    ;; destinguish between Ctrl-m and RET due to historical reasons
    ;; https://emacs.stackexchange.com/questions/20240/how-to-distinguish-c-m-from-return
    (define-key input-decode-map [?\C-\M-M] [C-M-m])
    (define-key input-decode-map [?\M-n] [M-n])
    (define-key map (kbd "M-m") (lambda ()
				  (interactive)
				  (move-end-of-line 1)
				  (newline-and-indent)))
    ;; Including the shift for adding a comment at the beginning
    ;; of the new line.
    (define-key map (kbd "M-M") (lambda ()
				    (interactive)
				    (move-end-of-line 1)
				    (comment-indent-new-line)
				    (self-insert-command 1)))
    (define-key map (kbd "<C-M-m>")
      (lambda ()
	(interactive)
	(if (string= (what-line) "Line 1")
	    (progn
	      (move-beginning-of-line 1)
	      (newline-and-indent)
	      (previous-line))
	  (progn
	    (previous-line)
	    (move-end-of-line 1)
	    (newline-and-indent)))))
    map)
  "custom-keys-minor-mode keymap.")

;; Activating the customized keybindings with every major mode.
(define-minor-mode custom-keys-minor-mode
  "Enforcing my customized keys on all major modes/"
  :init-value t
  :lighter " custom-keys")
(custom-keys-minor-mode 1)

;; C-n is reserved for evaluating a region and thus has to assigned
;; for each mode independently
(add-hook 'ess-mode-hook
	  (lambda()
	    (local-set-key (kbd "M-j") 'left-word)
	    (local-set-key (kbd "C-n")
			   'ess-eval-region-or-line-and-step)
	    (local-set-key (kbd "<M-n>")
			   (lambda()
			     (interactive)
			     ;; Check whether this is a .R or .Rmd document
			     (if (string= (subseq buffer-file-name
						  (- (length buffer-file-name) 2))
					  ".R")
				 (progn
				   ;; It's a .R file. Evaluate the whole document.
				   (ess-eval-paragraph-and-step))
			       ;; It's a .Rmd file. Export it to .html
				   (ess-eval-chunk 1))))
	    ;; compile the whole file
	    (local-set-key (kbd "C-M-n")
			   (lambda()
			     (interactive)
			     ;; Check whether this is a .R or .Rmd document
			     (if (string= (subseq buffer-file-name
						  (- (length buffer-file-name) 2))
					  ".R")
				 ;; It's a .R file. Evaluate the whole document.
				 (progn
				   (mark-whole-buffer)
				   (ess-eval-region
				    (region-beginning)
				    (region-end)
				    nil))
			       ;; It's a .Rmd file. Export it to .html
			       (polymode-export "Rmarkdown" "html"))))))
;; In order to work in the markdown part of ESS as well
(add-hook 'markdown-mode-hook
	  (lambda()
	    (local-set-key (kbd "C-M-n")
			   (lambda()
			     (interactive)
			     ;; Check whether this is a .R or .Rmd document
			     (if (string= (subseq buffer-file-name
						  (- (length buffer-file-name) 2))
					  ".R")
				 ;; It's a .R file. Evaluate the whole document.
				 (progn
				   (mark-whole-buffer)
				   (ess-eval-region
				    (region-beginning)
				    (region-end)
				    nil))
			       ;; It's a .Rmd file. Export it to .html
			       (polymode-export "Rmarkdown" "html"))))))
(add-hook 'python-mode-hook
	  (lambda()
	    (local-set-key (kbd "<C-return>")
			   (lambda ()
			     (interactive)
			     (py-execute-line)
			     (next-line)))
	    (local-set-key (kbd "C-n")
			   (lambda ()
			     (interactive)
			     (py-execute-line)
			     (next-line)))
	    (local-set-key (kbd "<M-return>")
			   (lambda ()
			     (interactive)
			     (py-execute-region)
			     (py-switch-to-shell)))
	    (local-set-key (kbd "M-n")
			   (lambda ()
			     (interactive)
			     (py-execute-region)
			     (py-switch-to-shell)))
	    (local-set-key (kbd "C-M-n") 'py-execute-buffer)))

;; using conf-mode for frequently visited configuration scripts
(add-to-list 'auto-mode-alist '(".asoundrc" . conf-mode))
(add-to-list 'auto-mode-alist '("\\config\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.conf\\'" . conf-mode))
	     
	     
