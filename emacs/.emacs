;; Customization of the glorious Emacs
;; The screen of abyzou (my Acer laptop) is not that big. Use just two
;; spaces for indention
(setq standard-indent 2)
(setq tab-width 2)

;; loading personal scripts and functions from ~elisp
(defvar elisp-path '("~/git/configurations-and-scripts/emacs/elisp/"))
(mapcar #'(lambda(p) (add-to-list 'load-path p)) elisp-path)

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

;; Add a german dictionary and the option of switching between
;; languages
(defun flyspell-switch-dictionary()
  (interactive)
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
(setq R-binary-folder "/home/phil/software/R/R-3.3.2/bin/")

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

;; (setq default-abbrev-mode t)
(setq save-abbrevs nil)
(load "~/git/configurations-and-scripts/emacs/.emacs.d/abbrev_defs.el")
;; this stupid thing just don't seems to work. Skeletons have to be inserted by hand.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq load-path (cons "~/git/configurations-and-scripts/emacs/org-mode/lisp" load-path))
(setq load-path (cons "~/git/configurations-and-scripts/emacs/org-mode/contrib/lisp" load-path))
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock)

;; (add-to-list 'load-path (expand-file-name "~/git/org-mode/lisp"))
;; (add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode ))
(require 'org)

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-log-done t) ;; Displayes the closed date whenever a TODO is marked as DONE
(setq org-agenda-files (list "~/git/tsa/org/work.org"
			     "~/git/tsa/org/interest.org"
			     "~/git/tsa/org/private.org"
			     "~/git/tsa/org/software.org"
			     "~/git/tsa/org/notes/papers.org"
			     "~/git/tsa/org/refile.org"
			     "~/git/tsa/org/notes/algorithms-computation.org"))

;; specification for capturing and refiling
(global-set-key (kbd "C-c c") 'org-capture)
(defun foreign-verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))
(setq 
 org-directory "~/git/tsa/org"
 org-default-notes-files "~/git/tsa/org/refile.org"
 org-capture-templates (quote (("t" "todo" entry (file "~/git/tsa/org/refile.org")
				"* TODO %? \n%U\n%a\n")
			       ("n" "note" entry (file "~/git/tsa/org/refile.org")
				"* %? :NOTE:\n%U\n")))
 org-refile-targets (quote ((nil :maxlevel . 9)
			    (org-agenda-files :maxlevel . 9 ))) ; current file and all contributing to agenda are refiling targets - up to 9 levels deep
 org-refile-use-outline-path t
 org-outline-path-complete-in-steps nil
 org-refile-allow-creating-parent-nodes (quote confirm) ; allow refile to create parent tasks with confirmation
 org-completion-use-ido t
 org-indirect-buffer-display 'current-window
 org-refile-target-verify-function 'foreign-verify-refile-target ; exclude DONE state
)

;; customize agenda view
(setq
 org-agenda-dim-blocked-tasts nil
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

;; userspecific tags
(setq 
 org-tag-alist (quote ((:startgroup)
			    ("@WORK" . ?W)
			    ("@HOME" . ?H)
			    ("@BEHEMOTH" . ?B)
			    ("@LEVIATHAN" . ?L)
			    ("@ZYZ" .?Z)
			    ("@ILMENAU" . ?I)
			    ("@SANGERHAUSEN" . ?S)
			    (:endgroup)
			    ("work" . ?w)
			    ("records" . ?r)
			    ("paper" . ?p)
			    ("visualization" . ?v)
			    ("software" . ?s) ; new software to dig in
			    ("material" . ?m) ; other sources than papers
			    ("climate" . ?c)
			    ("extremes" . ?e)
			    ("buy" . ?b)
			    ("lam" . ?l)
			    ("formality" . ?f)))
 org-fast-tag-selection-single-key (quote expert)
 org-agenda-tags-todo-honor-ignore-options t
)

;; archive setup
(setq org-archive-mark-done nil)
(setq org-archive-location "%s_archive::* Archived Tasks")
(defun foreign-skip-non-archivable-tasks ()
      "Skip trees that are not available for archiving"
      (save-restriction
	(widen)
	;; consider only tasks with done todo headings
	(let ((next-headline (save-excursion (or (outline-next-heading) (point-max))))
	      (subtree-end (save-excursion (org-end-0of-subtree t))))
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
(require 'ox-ascii)

(defun foreign-display-inline-images ()
  (condition-case nil
      (org-display-inline-images)
    (error nil)))
(add-hook 'org-babel-after-execute-hook 'foreign-display-inline-images 'append)
(add-to-list 'org-src-lang-modes (quote ("plantuml" . fundamental)))
(setq
 org-ditaa-jar-path "~/git/configurations-and-scripts/emacs/org-mode/contrib/scripts/ditaa.jar"
 org-plantuml-jar-path "~/scripts/java/plantuml.jar"
 org-babel-results-keyword "results" ; make babel results blocks lowercase
 org-confirm-babel-evaluate nil
 org-startup-with-inline-images nil ; cause it breaks when accessing via ssh
 org-babel-R-command (concatenate 'string R-binary-folder "R --no-save --slave")
)
(org-babel-do-load-languages
 (quote org-babel-load-languages)
 (quote ((emacs-lisp . t)
	 (dot . t)
	 (ditaa . t)
	 (R . t)
	 (python . t)
	 (ruby . t)
	 (gnuplot . t)
	 (clojure . t)
	 (sh . t)
	 (ledger . t)
	 (org . t)
	 (plantuml . t)
	 (latex . t))))


;; skeletons
(add-hook 'org-mode-hook (lambda () (abbrev-mode 1)))
(define-skeleton skel-org-block
  "Insert an org block, querying for type."
  "Type: "
  "#+begin_" str "\n"
  _ - \n
  "#+end_" str "\n")
(define-abbrev org-mode-abbrev-table "sblk" "" 'skel-org-block)
(define-skeleton skel-org-block-plantuml
  "Insert a org plantuml block, querying for filename."
  "File (no extension): "
  "#+begin_src plantuml :file " str ".png :cache yes\n"
  _ - \n
  "#+end_src\n")
(define-abbrev org-mode-abbrev-table "splantuml" "" 'skel-org-block-plantuml)

;; MobileOrg
(setq org-mobile-directory "~/Dropbox/MobileOrg")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; org-mode

;; abbreviations
(setq 
 abbrev-file-name "~/git/configurations-and-scripts/emacs/.emacs.d/abbrev_defs.el"
 save-abbrevs t
)

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; From emacs-fu.blogspot.de
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
;; Macro for using packages and functions only when they are available
(defmacro require-maybe (feature &optional file)
  "*Try to require FEATURE, but don't signal an error if 'require' fails. "
  `(require, feature, file 'noerror))

(defmacro when-available (func foo)
  "*Do something if FUNCTION is available."
  `(when (fboundp, func) ,foo))

;; running external programs only if they exists
(defun foreign-shell-command-maybe (exe &optional paramstr)
  "run executable EXE with PARAMSTR, or warn if EXE's not available; eg. "
  " (foreign-shell-command-mazbe \"ls\" \"-l -a\")"
  (if (executable-find exe)
      (shell-command (concat exe " " paramstr))
    (message (concat "'" exe "' not found; please install"))))

;; Zooming in or out in Emacs
(defun foreign-zoom (n)
  "with positive N, increase the font size, otherwise decrese it"
  (set-face-attribute 'default (selected-frame) :height
		      (+ (face-attribute 'default :height (* *if (> n 0) 1 -1) 10))))
;; keybinding of the zoom function: Crtl-+ for zooming in, Crtl-- for zooming out
(global-set-key (kbd "C-+")      '(lambda nil (interactive) (foreign-zoom 1)))
(global-set-key [C-kp-add]       '(lambda nil (interactive) (foreign-zoom 1)))
(global-set-key (kbd "C--")      '(lambda nil (interactive) (foreign-zoom -1)))
(global-set-key [C-kp-substract] '(lambda nil (interactive) (foreign-zoom -1)))

;; running emacs in full-screen mode
(defun foreign-full-screen-toggle ()
  "toggle full-screen mode"
  (interactive)
  (shell-command "wmctrl -r :ACTIVE: -btoggle,fullscreen"))
(global-set-key (kbd "<f11>") 'foreign-full-screen-toggle)

;; enable time stamp and automatic time stamp when saving data
(setq
 time-stamp-active t
 time-stamp-lin-limit 10 ; check first 10 buffer lines for Time-stamp
 time-stamp-format "%04y-%02m-%02d %02H:%02M:%02S (%u)")
(add-hook 'write-file-hooks 'time-stamp); update when saving

;; show column numbers
(column-number-mode t)

;; show line numbers
(autoload 'linum-mode "linum" "toggle line numbers on/off" t)
(global-set-key (kbd "C-<f5>") 'linum-mode)
(add-hook 'ess-mode-hook
	  (lambda() 'linum-mode 1))

;; highlight current line
;; color is chosen which is not available on the console. so there is only line highlighting in the emacs GUI
(defface hl-line '((t (:ba ckground "WhiteSmoke")));"LightSteelBlue1")))
  "Face to use for 'hl-line-face'. " :group 'hl-line)
(if (eq window-system 'x) 
    (setq hl-line-face 'hl-line)
  (global-hl-line-mode t))


;; hightlighting "TODO" and "BUG" in ESS
(add-hook 'ess-mode-hook
	  (lambda ()
	    (font-lock-add-keywords nil
				    '(("\\<\\(TODO\\|BUG\\|UPDATE\\|NEW\\):" 1 font-lock-warning-face t)))))

;; selection and cut-copy-paste like everywhere else 
(transient-mark-mode t)   ; display current selection in a different color + windowsstyle region marking (shift)
(delete-selection-mode t) ; delete selected area with a keypress

;; bremapping caps-lock to M-x
;;(if (eq window-system 'x)
;;   (shell-command "xmodmap -e 'clear Lock' -e 'keycode 66 = F13'"))
;;(global-set-key [f13] 'execute-extended-command)

;; bcycling hrough your buffers with Ctrl-Tab
(global-set-key (kbd "<C-tab>") 'bury-buffer)

;; easier switchting between buffers (with alt key)
(require 'windmove)
(windmove-default-keybindings 'meta)

;; enable rectangle marking
(require 'rect-mark)
(global-set-key (kbd "C-x r C-SPC") 'rm-set-mark)
(global-set-key (kbd "C-x r C-x")   'rm-exchange-point-and-mark)
(global-set-key (kbd "C-x r C-w")   'rm-kill-region)
(global-set-key (kbd "C-x r M-W")   'rm-kill-ring-save)

;; ;; viewing register contents
(require 'list-register)
(global-set-key (kbd "C-x r v") 'list-register)

;; counting words
(defun foreign-count-words (&optional begin end)
  "count words between BEGIN and END (region); if no region defined, count words in buffer"
  (interactive "r")
  (let ((b (if mark-active begin (point-min)))
	(e (if mark-active end (point-max))))
    (message "Word count: %s" (how-many "\\w+" b w ))))

;; show mismatching parantheses (out of a sudden this seems to be invalid)
;; (set-face-foreground 'show-paren-mismatch-face "red")
;; (set-face-attribute 'show-paren-mismatch-face nil
;;		    :weight 'bold :underline t :overline nil :slant 'normal)

;; shows a list of possible matching entries while switching buffer or finding files
(require 'ido)
(ido-mode 'both) ;; for buffers and files
(setq
 ido-save-directory-list-file "~/git/configurations-and-scripts/emacs/.emacs.d/cache/ido.last"
 ido-everywhere t
 ido-max-directory-size 100000
 ido-default-file-method 'selected-window ; use current window when visiting files
 ido-default-buffer-method 'selected-window
 ido-ignore-buffers ;;
 '("\\` " "^\*Mess" "^\*Back" ".*Completion" "^\*Ido" "^\*trace"
"^\*compilation" "^\*GTAGS" "^session\.*" "^\*")
 ido-work-directory-list '("~/" "~/Desktop" "~/Documents" "~src")
 ido-case-fold t ; case sensitive
 ido-enable-last-directory-history t ; remeber last used dirs
 ido-max-work-directory-list 30
 ido-max-work-file-list 50
 ido-use-filename-at-point nil
 ido-use-url-at-point nil
 
 ido-enable-flex-matching nil ; don't try to be too smart
 ido-max-prospects 8 ; don't spam minibuffer
 ido-confirm-unique-completion t) ; wait for RET even with uniwue completion
(setq confirm-nonexistent-file-or-buffer nil) ; when using ido, this is quite annoying

;; make emacs transparent (which might be a little bit useless)
(defun foreign-opacity-modify (&optional dec)
  "modify the transparency of the emacs frame; if DEC is t, decrease the transparency, otherwise increase it in 10%-steps"
  (let* ((alpha-or-nil (frame-parameter nil 'alpha)) ; nil before setting
	 (oldalpha (if alpha-or-nil alpha-or-nil 100))
	 (newalpha (if dec (- oldalpha 10) (+ oldalpha 10))))
    (when (and (>= newalpha frame-alpha-lower-limit) (<= newalpha 100))
      (modify-frame-parameters nil (list (cons 'alpha newalpha))))))

;; C-8 increase opacity
;; C-9 decrease opacity
;; C-0 default
(global-set-key (kbd "C-8") '(lambda()(interactive)(foreign-opacity-modify)))
(global-set-key (kbd "C-9") '(lambda()(interactive)(foreign-opacity-modify t)))
(global-set-key (kbd "C-0") '(lambda()(interactive)(modify-frame-parameters nil `((alpha . 100)))))

;; activating smex for 'ido' like search in the emacs commands
(setq smex-save-file "~/git/configurations-and-scripts/emacs/.emacs.d/smex.save")
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-X") 'smex)

;; highlight changes in files under version control
(global-highlight-changes-mode t)
(setq highlight-changes-visibility-initial-state nil); initially hidden
(global-set-key (kbd "<f6>") 'highlight-changes-visible-mode) ;; toggle visibility
(global-set-key (kbd "S-<f6>") 'higlight-changes-remove-highlight)
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

;; elscreen. Treats all buffers which are opened in elscreen-buffer as a logical unit. This eases the task of switching between various buffers at once
(load "elscreen" "ElScreen")
(global-set-key (kbd "<f9>") 'elscreen-create)
(global-set-key (kbd "S-<f9>") 'elsceen-kill)
;; windows key + PgUp/Down switches between elscreens
(global-set-key (kbd "<s-prior>") 'elscreen-previous)
(global-set-key (kbd "<s-next>") 'elscree-next)

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
	       ("Extremes"
		(filename . "~/calculations/"))
	       ("Configuration"
		(or 
		 (filename . "~/")
		 (filename . "~/git/configurations-and-scripts/emacs/.emacs.d/")
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
  (eval-after-load "abbrev"
    '(diminish 'abbrev-mode "Ab"))
  (eval-after-load "yasnippet"
    '(diminish 'yas-minor-mode " Y")))
(add-hook 'emacs-lisp-mode-hook
	  (lambda() (setq mode-name "el")))

;; browse through kill-ring (but also try M-y)
(when (require 'browse-kill-ring nil 'noerror)
  (browse-kill-ring-default-keybindings))
(global-set-key "\C-cy" '(lambda()
			   (interactive)
			   (popup-menu 'yank-menu)))

;; obsolete since a custom modeline is used
;; displaing scrolling information in mode-bar
;; (if (require 'sml-modeline nil 'noerror)
;;     (progn (sml-modeline-mode 1))) ;; but this is also present in minimal-mode

;; kills buffers which are more than 3 days untouched
(require 'midnight)

;; using anything to find things
(add-to-list 'load-path "~/git/configurations-and-scripts/emacs/anything-config")
(require 'anything-config)
(global-set-key (kbd "C-x b")
		(lambda() (interactive)
		  (anything
		   :prompt "Switch to: "
		   :candidate-number-list 10
		   :sources
		   '( anything-c-source-buffers
		      anything-c-source-recentf
		      anything-c-source-bookmarks
		      anything-c-source-files-in-current-dir+
		      anything-c-source-locate))))


;; colorful delimiters 
(when (require 'rainbow-delimiters nil 'noerror)
  (lambda()
    (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
    (add-hook 'ess-mode-hook 'rainbow-delimiters-mode)
    (add-hook 'lisp-mode-hook 'rainbow-delimiters-mode)
    (add-hook 'python-mode-hook 'rainbow-delimiters-mode)))
(rainbow-delimiters-mode 1)

;; using multi-term to open more than one terminal in emacs
(autoload 'multi-term "multi-term" nil t)
(autoload 'multi-term-next "multi-term" nil t)
(setq multi-term-program "/bin/bash")
(global-set-key (kbd "C-c t") 'multi-term-next)
(global-set-key (kbd "C-c T") 'multi-term)

;; more packages
(setq package-archives '(("ELPA" . "http://tromey.com/elpa/")
			 ("gnu" . "http://elpa.gnu.org/packages/")
			 ;; ("marmalade" . "http://marmalade-repo.org/packages/")
			 ;; seems not to work right now
			 ))

;; changing the style of the modline
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; emacs-fu

;;; diverse

;; source the .emacs file after alteration while still running an active emacs session
(defun reload ()
  (interactive)
  (load-file "~/.emacs"))
(defun corg ()
  (interactive)
  (dired-at-point "~/git/tsa/org"))

;; dismissing the startup screen
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#3F3F3F" "#CC9393" "#7F9F7F" "#F0DFAF" "#8CD0D3" "#DC8CC3" "#93E0E3" "#DCDCCC"])
 '(custom-safe-themes (quote ("6383295fb0c974d24c9dca1230c0489edf1cd5dd03d4b036aab290b6d3ceb50c" default)))
 '(delete-selection-mode nil)
 '(fci-rule-color "#383838")
 '(inhibit-startup-screen t)
 '(mark-even-if-inactive t)
 '(org-agenda-files (quote ("~/git/tsa/org/work.org" "~/git/tsa/org/private.org" "~/git/tsa/org/software.org" "~/git/tsa/org/refile.org")))
 '(scroll-bar-mode (quote right))
 '(transient-mark-mode 1)
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map (quote ((20 . "#BC8383") (40 . "#CC9393") (60 . "#DFAF8F") (80 . "#D0BF8F") (100 . "#E0CF9F") (120 . "#F0DFAF") (140 . "#5F7F5F") (160 . "#7F9F7F") (180 . "#8FB28F") (200 . "#9FC59F") (220 . "#AFD8AF") (240 . "#BFEBBF") (260 . "#93E0E3") (280 . "#6CA0A3") (300 . "#7CB8BB") (320 . "#8CD0D3") (340 . "#94BFF3") (360 . "#DC8CC3")))) ;
 '(vc-annotate-very-old-color "#DC8CC3")
 ;; But I'm a naughty boy and did edit it by hand.
 '(polymode-exporter-output-file-format "%s"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

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
;; Use the TAB to call the py-indent-line function
(setq py-tab-indent t)

;; load the python-mode for .bzl files since their Skylark language
;; resembles in some way the python syntax
(setq auto-mode-alist (cons '(".bzl$" . python-mode) auto-mode-alist))

;; use flyspell
(add-hook 'python-mode-hook
	  (lambda()
	    (setq py-indent-offset 2)
	    (local-set-key (kbd "<C-return>")
			   (lambda ()
			     (interactive)
			     (py-execute-region)))))
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
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.prg/packages/")))
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

;; (autoload 'gfm-mode "gfm-mode"
;;    "Major mode for editing GitHub Flavored Markdown files" t)
;; (add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
;; (eval-after-load "markdown-mode"
;;   '(defalias 'markdown-add-xhtml-header-and-footer 'as/markdown-add-xhtml-header-and-footer))

(defun as/markdown-add-xhtml-header-and-footer (title)
    "Wrap XHTML header and footer with given TITLE around current buffer."
    (goto-char (point-min))
    (insert "<!DOCTYPE html5>\n"
	    "<html>\n"
	    "<head>\n<title>")
    (insert title)
    (insert "</title>\n")
    (insert "<meta charset=\"utf-8\" />\n")
    (when (> (length markdown-css-paths) 0)
      (insert (mapconcat 'markdown-stylesheet-link-string markdown-css-paths "\n")))
    (insert "\n</head>\n\n"
	    "<body>\n\n")
    (goto-char (point-max))
    (insert "\n"
	    "</body>\n"
	    "</html>\n"))

;; colors and human readable file size in dired
(setq dired-listing-switches "-alh")

;; transparent background
(set-frame-parameter (selected-frame) 'alpha '(77 . 50))
(add-to-list 'default-frame-alist '(alpha . (77 . 50)))
 
(set-face-attribute 'default nil :background "black")

;; working with both html and javascript in one document
;; (require 'multi-web-mode)
;; (setq mweb-default-major-mode 'html-mode)
;; (setq mweb-tags '((js-mode "<script[^>]*>" "</script>")
;;                   (php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
;;                   (css-mode "<style[^>]*>" "</style>")))
;; (setq mweb-filename-extensions '("php" "htm" "html" "xhtml" "ctp" "phtml" "php4" "php5"))
;; (multi-web-global-mode 1)

;; use perl-mode for perl scripts
(add-to-list 'auto-mode-alist '("\\.plx" . perl-mode))
(add-to-list 'auto-mode-alist '("\\.pl" . perl-mode))

;; flycheck
;; wdired/ranger
;; tramp
;; font Consolas-12; Symbola
;; epa
;; whitespace mode
;; ido
;; magit
;; helm/yedi

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



;; Customized keybindings for navigation, killing and various other
;; useful things.
;; In order to not consider any special cases and to not get annoyed by
;; minor-mode key maps (especially flyspell), I will define my own
;; minor-mode which enforces my custom key bindings on all the major
;; modes. Whenever I want to switch back to the original key bindings,
;; I just disable this minor-mode.
(defvar custom-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))
    ;; Comment and indent
    (define-key map (kbd "M-'") 'comment-dwim)
    (define-key map (kbd "C-'") 'indent-region)
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
    (define-key map (kbd "M-j") 'left-word)
    (define-key map (kbd "M-l") 'forward-paragraph)
    (define-key map (kbd "M-k") 'backward-paragraph)
    (define-key map (kbd "M-;") 'right-word)
    (define-key map (kbd "C-M-j") 'move-beginning-of-line)
    (define-key map (kbd "C-M-k") 'beginning-of-buffer)
    (define-key map (kbd "C-M-l") 'end-of-buffer)
    (define-key map (kbd "C-M-;") 'move-end-of-line)
    ;; Killing
    (define-key map (kbd "C-,") 'backward-delete-char-untabify)
    (define-key map (kbd "C-.") 'delete-forward-char)
    (define-key map (kbd "M-,") 'backward-kill-word)
    (define-key map (kbd "M-.") 'kill-word)
    (define-key map (kbd "C-M-.") 'kill-line)
    (define-key map (kbd "C-M-,") 'kill-whole-line)
    ;; Binding something to Ctrl-m causes problems because Emacs does not
    ;; destinguish between Ctrl-m and RET due to historical reasons
    ;; https://emacs.stackexchange.com/questions/20240/how-to-distinguish-c-m-from-return
    (define-key input-decode-map [?\C-\M-M] [C-M-m])
    (define-key map (kbd "M-m") (lambda ()
				    (interactive)
				    (move-end-of-line 1)
				    (newline-and-indent)))
    (define-key map (kbd "<C-M-m>") (lambda ()
				      (interactive)
				      (previous-line)
				      (move-end-of-line 1)
				      (newline-and-indent)))
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
	    (local-set-key (kbd "C-n")
			   'ess-eval-region-or-line-and-step)
	    (local-set-key (kbd "M-n")
			   (lambda()
			     (interactive)
			     (ess-eval-chunk)))
	    ;; compile the whole file
	    (local-set-key (kbd "C-M-n")
			   (lambda()
			     (interactive)
			     (polymode-export "Rmarkdown" "html")))))
;; In order to work in the markdown part of ESS as well
(add-hook 'markdown-mode-hook
	  (lambda()
	    (local-set-key (kbd "C-M-n")
			   (lambda()
			     (interactive)
			     (polymode-export "Rmarkdown" "html")))))
(add-hook 'python-mode-hook
	  (lambda()
	    (local-set-key (kbd "<C-return>")
			   (lambda ()
			     (interactive)
			     (py-execute-line)
			     (py-switch-to-shell)))
	    (local-set-key (kbd "C-n")
			   (lambda ()
			     (interactive)
			     (py-execute-line)
			     (py-switch-to-shell)))
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
