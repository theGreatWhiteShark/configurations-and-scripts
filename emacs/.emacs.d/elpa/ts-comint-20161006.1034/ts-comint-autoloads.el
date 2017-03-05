;;; ts-comint-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "ts-comint" "ts-comint.el" (22563 39646 871463
;;;;;;  25000))
;;; Generated autoloads from ts-comint.el

(autoload 'run-ts "ts-comint" "\
Run an inferior Typescript process, via buffer `*Typescript*'.
If there is a process already running in `*Typescript*', switch
to that buffer.  With argument `CMD', allows you to edit the
command line (default is value of `ts-comint-program-command').
Runs the hook `ts-comint-mode-hook' (after the
`comint-mode-hook' is run).  (Type \\[describe-mode] in the
process buffer for a list of commands). Use `DONT-SWITCH-P' to
prevent switching to the new buffer once created.

\(fn CMD &optional DONT-SWITCH-P)" t nil)

(autoload 'ts-send-string "ts-comint" "\
Send `TEXT' to the inferior Typescript process.

\(fn TEXT)" t nil)

(autoload 'ts-send-region "ts-comint" "\
Send the current region to the inferior Typescript process.

\(fn START END)" t nil)

(autoload 'ts-send-region-and-go "ts-comint" "\
Send the current region to the inferior Typescript process.

\(fn START END)" t nil)

(autoload 'ts-send-last-sexp-and-go "ts-comint" "\
Send the previous sexp to the inferior Typescript process.

\(fn)" t nil)

(autoload 'ts-send-last-sexp "ts-comint" "\
Send the previous sexp to the inferior Typescript process.

\(fn)" t nil)

(autoload 'ts-send-buffer "ts-comint" "\
Send the buffer to the inferior Typescript process.

\(fn)" t nil)

(autoload 'ts-send-buffer-and-go "ts-comint" "\
Send the buffer to the inferior Typescript process.

\(fn)" t nil)

(autoload 'ts-load-file "ts-comint" "\
Load file `FILENAME' in the Typescript interpreter.

\(fn FILENAME)" t nil)

(autoload 'ts-load-file-and-go "ts-comint" "\
Load file `FILENAME' in the Typescript interpreter.

\(fn FILENAME)" t nil)

(autoload 'switch-to-ts "ts-comint" "\
Switch to the Typescript process buffer.
With argument `EOB-P', position cursor at end of buffer.

\(fn EOB-P)" t nil)

(autoload 'ts-comint-mode "ts-comint" "\
Major mode for interacting with an inferior Typescript process.

The following commands are available:
\\{ts-comint-mode-map}

A typescript process can be fired up with M-x run-ts.

Customization: Entry to this mode runs the hooks on comint-mode-hook and
ts-comint-mode-hook (in that order).

You can send text to the inferior Typescript process from other buffers containing
Typescript source.
    switch-to-ts switches the current buffer to the Typescript process buffer.
    ts-send-region sends the current region to the Typescript process.

\(fn)" t nil)

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; ts-comint-autoloads.el ends here
