;;; lua-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "lua-mode" "lua-mode.el" (21917 43854 702208
;;;;;;  573000))
;;; Generated autoloads from lua-mode.el

(autoload 'lua-mode "lua-mode" "\
Major mode for editing Lua code.
The following keys are bound:
\\{lua-mode-map}

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))

(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; lua-mode-autoloads.el ends here
