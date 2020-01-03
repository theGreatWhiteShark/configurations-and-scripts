;;; hydrogen.el - Some auxiliary functions to edit h2song XML files of
;;; the Hydrogen drum sequencer.

;; Created: <2018-25-02 01:14:00 Philipp Müller>
;; Author: Philipp Müller <thetruephil@googlemail.com>
;; Compatibility: GNU Emacs: >=25.1

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; To use these functions, you have to `load' this file into Emacs.
;; This can be done by adding the following lines to your .emacs file
;; in your home. 
;;
;;   ;; Load some custom functions to edit Hydrogen files
;;   (load "PATH-TO-YOUR-COPY-OF/hydrogen.el")
;;
;; Functions defined within this file
;;
;;   `hydrogen-swap-instruments'
;;
;;     Interactive function to swap two instruments in patterns.
;;
;;     Did you ever switched to a drum kit in Hydrogen, which does not
;;     hold the instruments in the exact same position? Well, you
;;     definitely do not want to change all the activations by hand.
;;
;;     This function is a more fail-save version of the
;;     `hydrogen-replace-instrument' function. Sometimes you are not
;;     are of rare activations of some instruments in some remote
;;     patterns. Swapping instead of replacing prevents mixing up
;;     those activations with the ones you are about to change. In
;;     case there is no instrument present matching the second, the
;;     TO, argument, an ordinary replacement will be performed. 
;;
;;     In a Hydrogen file all patterns are listed inside a
;;     <patternList> tag. With no region marked the function will act
;;     on all of these patterns and replaces the number of
;;     instrument. If, instead, a region is marked, this function will
;;     act only on it. 
;;
;;     But keep in mind: the enumeration of the instruments starts at
;;     0! 
;;
;;   `hydrogen-replace-instruments'
;;
;;     Interactive function to replace an instrument in patterns.
;;
;;     Did you ever switched to a drum kit in Hydrogen, which does not
;;     hold the instruments in the exact same position? Well, you
;;     definitely do not want to change all the activations by hand.
;;
;;     In a Hydrogen file all patterns are listed inside a
;;     <patternList> tag. With no region marked the function will act
;;     on all of these patterns and replaces the number of
;;     instrument. If, instead, a region is marked, this function will
;;     act only on it. 
;;
;;     But keep in mind: the enumeration of the instruments starts at
;;     0!
;;
;;   `hydrogen-swap-instruments-non-interactive'
;;
;;     Non-interactive version of `hydrogen-swap-instruments' and
;;     `hydrogen-replace-instruments'.
;;
;;     If the third parameter `replace' is nil, the instrument IDs
;;     corresponding to `old' and `new' will be swapped. If non-nil,
;;     the will be replaced instead.
;;
;;   `hydrogen-swap-forzeeStereo-and-Flac-GSCW-2'
;;
;;     Switch from the ForzeeStereo Hydrogen drumkit to the
;;     Flac-GSCW-2 kit.
;;
;;     Please note that this function will only work properly when
;;     executed in a buffer visiting the .h2song file of a recent
;;     (1.0.0*) version of the Hydrogen drum computer.
;;
;;   `hydrogen-swap-gmkit-and-forzeeStereo'
;;
;;     Please use with caution. Legacy and not tested recently.
;;
;;   `hydrogen-swap-lamkit-and-forzeeStereo'
;;
;;     Please use with caution. Legacy and not tested recently.


(defun hydrogen-swap-instruments ()
  "Interactive function to two instruments in patterns.

Did you ever switched to a drum kit in Hydrogen, which does not hold
the instruments in the exact same position? Well, you definitely do
not want to change all the activations by hand.

This function is a more fail-save version of the
`hydrogen-replace-instrument' function. Sometimes you are not are of
rare activations of some instruments in some remote patterns. Swapping
instead of replacing prevents mixing up those activations with the
ones you are about to change. In case there is no instrument present
matching the second, the TO, argument, an ordinary replacement will be
performed. 

In a Hydrogen file all patterns are listed inside a <patternList>
tag. With no region marked the function will act on all of these
patterns and replaces the number of instrument. If, instead, a region
is marked, this function will act only on it.

But keep in mind: the enumeration of the instruments starts at 0!
"
  (interactive)
  ;; In order to swap two instruments we need an auxiliary instrument
  ;; number to swap the first one to before replacing it. A sufficient
  ;; high number shouldn't interfere with the settings of any user.
  (setq hydrogen-auxiliary-instrument "555")
  ;; Unset the query defaults, since they wouldn't be of any help and
  ;; interfere with the from query.
  (setq query-replace-defaults nil)
  ;; Ask the user which instrument should be replaced via a prompt.
  (if mark-active
      (setq hydrogen-swap-instrument-from
			(query-replace-read-from
			 "Swap instrument (starts at 0) in region" ""))
    (setq hydrogen-swap-instrument-from
		  (query-replace-read-from
		   "Swap instrument (starts at 0) in all patterns" "")))
  ;; What should it be replaced with?
  (if mark-active
      (setq hydrogen-swap-instrument-to
			(query-replace-read-to
			 ""
			 (concat "Swap instrument (starts at 0) in region '"
					 hydrogen-swap-instrument-from "'") ""))
    
    (setq hydrogen-swap-instrument-to
		  (query-replace-read-to
		   ""
		   (concat "Swap instrument (starts at 0) in all patterns '"
				   hydrogen-swap-instrument-from "'") "")))
  ;; The actual replacement.
  ;; If for some reason the user inserted the same argument for the
  ;; FROM and TO argument, just skip the replacement
  (unless (string= hydrogen-swap-instrument-from
				   hydrogen-swap-instrument-to)
    ;; Determine region the function should act upon.
    (save-excursion
      (if mark-active
		  (progn
			;; Remember the region
			(setq hydrogen-swapping-region-beginning (region-beginning))
			(setq hydrogen-swapping-region-end (region-end)))
		(progn
		  ;; Perform the replacement in all the available patterns of
		  ;; the pattern list. This region start with a <patternList>
		  ;; clause and ends with a </patternList> clause. As far as I
		  ;; understood the format of the file both tags should only
		  ;; appear once. 
		  ;; Firstly, the pattern list will be marked
		  (beginning-of-buffer)
		  (search-forward "<patternList>")
		  (set-mark (point))
		  (search-forward "</patternList>")
		  (setq hydrogen-swapping-region-beginning (region-beginning))
		  (setq hydrogen-swapping-region-end (point))))
      ;; Check whether TO argument is present in the buffer.
      (beginning-of-buffer)
      (if (search-forward (concat
						   "<instrument>"
						   hydrogen-swap-instrument-to) nil 0)
		  ;; Intermediate replace of the TO argument with the
		  ;; auxiliary one.
		  (progn
			(replace-string (concat
							 "<instrument>"
							 hydrogen-swap-instrument-to
							 "</instrument>")
							(concat
							 "<instrument>"
							 hydrogen-auxiliary-instrument
							 "</instrument>")
							nil
							hydrogen-swapping-region-beginning
							hydrogen-swapping-region-end)
			;; Replace the FROM with the TO argument.
			(replace-string (concat
							 "<instrument>"
							 hydrogen-swap-instrument-from
							 "</instrument>")
							(concat
							 "<instrument>"
							 hydrogen-swap-instrument-to
							 "</instrument>")
							nil 
							hydrogen-swapping-region-beginning
							hydrogen-swapping-region-end)
			;; Finally, replace the auxiliary on with the FROM. 
			(replace-string (concat
							 "<instrument>"
							 hydrogen-auxiliary-instrument
							 "</instrument>")
							(concat
							 "<instrument>"
							 hydrogen-swap-instrument-from
							 "</instrument>")
							nil
							hydrogen-swapping-region-beginning
							hydrogen-swapping-region-end))
		(progn
		  ;; The TO argument is not found in the buffer. Therefore
		  ;; an ordinary replacement takes place.
		  (replace-string (concat
						   "<instrument>"
						   hydrogen-swap-instrument-from
						   "</instrument>")
						  (concat
						   "<instrument>"
						   hydrogen-swap-instrument-to
						   "</instrument>")
						  nil
						  hydrogen-swapping-region-beginning
						  hydrogen-swapping-region-end)))))
  )

(defun hydrogen-replace-instrument ()
  "Interactive function to replace an instrument in patterns.

Did you ever switched to a drum kit in Hydrogen, which does not hold
the instruments in the exact same position? Well, you definitely do
not want to change all the activations by hand.

In a Hydrogen file all patterns are listed inside a <patternList>
tag. With no region marked the function will act on all of these
patterns and replaces the number of instrument. If, instead, a region
is marked, this function will act only on it.

But keep in mind: the enumeration of the instruments starts at 0!
"
  (interactive)
  ;; Unset the query defaults, since they wouldn't be of any help and
  ;; interfere with the from query.
  (setq query-replace-defaults nil)
  ;; Ask the user which instrument should be replaced via a prompt.
  (if mark-active
      (setq hydrogen-replace-instrument-from
			(query-replace-read-from
			 "Replace instrument (starts at 0) in region" ""))
    (setq hydrogen-replace-instrument-from
		  (query-replace-read-from
		   "Replace instrument (starts at 0) in all patterns" "")))
  ;; What should it be replaced with?
  (if mark-active
      (setq hydrogen-replace-instrument-to
			(query-replace-read-to
			 ""
			 (concat "Replace instrument (starts at 0) in region '"
					 hydrogen-replace-instrument-from "'") ""))
    
    (setq hydrogen-replace-instrument-to
		  (query-replace-read-to
		   ""
		   (concat "Replace instrument (starts at 0) in all patterns '"
				   hydrogen-replace-instrument-from "'") "")))
  ;; The actual replacement
  (if mark-active
      (replace-string  (concat
						"<instrument>"
						hydrogen-replace-instrument-from
						"</instrument>")
					   (concat
						"<instrument>"
						hydrogen-replace-instrument-to
						"</instrument>")
					   nil (region-beginning) (region-end))
    (save-excursion
      ;; Perform the replacement in all the available patterns of the
      ;; pattern list. This region start with a <patternList> clause
      ;; and ends with a </patternList> clause. As far as I understood
      ;; the format of the file both tags should only appear once.
      ;; Firstly, the pattern list will be marked
      (beginning-of-buffer)
      (search-forward "<patternList>")
      (set-mark (point))
      (search-forward "</patternList>")
      ;; Replacement
      (replace-string (concat
					   "<instrument>"
					   hydrogen-replace-instrument-from
					   "</instrument>")
					  (concat
					   "<instrument>"
					   hydrogen-replace-instrument-to
					   "</instrument>")
					  nil (region-beginning) (point))))
  )

(defun hydrogen-swap-instruments-non-interactive (old new replace)
  "Non-interactive version of `hydrogen-swap-instruments' and
  `hydrogen-replace-instruments'.

If the third parameter `replace' is nil, the instrument IDs
corresponding to `old' and `new' will be swapped. If non-nil, the will
be replaced instead."
  
  ;; In order to swap two instruments we need an auxiliary instrument
  ;; number to swap the first one to before replacing it. A sufficient
  ;; high number shouldn't interfere with the settings of any user.
  (setq hydrogen-auxiliary-instrument "555")
  ;; Unset the query defaults, since they wouldn't be of any help and
  ;; interfere with the from query.
  (setq query-replace-defaults nil)
  ;; Ask the user which instrument should be replaced via a prompt.
  (setq hydrogen-swap-instrument-from old)
  ;; What should it be replaced with?
  (setq hydrogen-swap-instrument-to new)
  ;; The actual replacement.
  ;; If for some reason the user inserted the same argument for the
  ;; FROM and TO argument, just skip the replacement
  (unless (string= hydrogen-swap-instrument-from
				   hydrogen-swap-instrument-to)
    ;; Determine region the function should act upon.
    (save-excursion
      (if mark-active
		  (progn
			;; Remember the region
			(setq hydrogen-swapping-region-beginning (region-beginning))
			(setq hydrogen-swapping-region-end (region-end)))
		(progn
		  ;; Perform the replacement in all the available patterns of
		  ;; the pattern list. This region start with a <patternList>
		  ;; clause and ends with a </patternList> clause. As far as I
		  ;; understood the format of the file both tags should only
		  ;; appear once. 
		  ;; Firstly, the pattern list will be marked
		  (beginning-of-buffer)
		  (search-forward "<patternList>")
		  (set-mark (point))
		  (search-forward "</patternList>")
		  (setq hydrogen-swapping-region-beginning (region-beginning))
		  (setq hydrogen-swapping-region-end (point))))
      ;; Check whether TO argument is present in the buffer.
      (beginning-of-buffer)
	  ;; The swapping of the instrument is a little bit more
	  ;; elaborated and will be split from the pure replacement for
	  ;; the sake of readability.
	  (if replace
		  (replace-string (concat
						   "<instrument>"
						   hydrogen-swap-instrument-from
						   "</instrument>")
						  (concat
						   "<instrument>"
						   hydrogen-swap-instrument-to
						   "</instrument>")
						  nil
						  hydrogen-swapping-region-beginning
						  hydrogen-swapping-region-end)
		(if (search-forward (concat
							 "<instrument>"
							 hydrogen-swap-instrument-to) nil 0)
			;; Intermediate replace of the TO argument with the
			;; auxiliary one.
			(progn
			  (replace-string (concat
							   "<instrument>"
							   hydrogen-swap-instrument-to
							   "</instrument>")
							  (concat
							   "<instrument>"
							   hydrogen-auxiliary-instrument
							   "</instrument>")
							  nil
							  hydrogen-swapping-region-beginning
							  hydrogen-swapping-region-end)
			  ;; Replace the FROM with the TO argument.
			  (replace-string (concat
							   "<instrument>"
							   hydrogen-swap-instrument-from
							   "</instrument>")
							  (concat
							   "<instrument>"
							   hydrogen-swap-instrument-to
							   "</instrument>")
							  nil 
							  hydrogen-swapping-region-beginning
							  hydrogen-swapping-region-end)
			  ;; Finally, replace the auxiliary on with the FROM. 
			  (replace-string (concat
							   "<instrument>"
							   hydrogen-auxiliary-instrument
							   "</instrument>")
							  (concat
							   "<instrument>"
							   hydrogen-swap-instrument-from
							   "</instrument>")
							  nil
							  hydrogen-swapping-region-beginning
							  hydrogen-swapping-region-end))
		  (progn
			;; The TO argument is not found in the buffer. Therefore
			;; an ordinary replacement takes place.
			(replace-string (concat
							 "<instrument>"
							 hydrogen-swap-instrument-from
							 "</instrument>")
							(concat
							 "<instrument>"
							 hydrogen-swap-instrument-to
							 "</instrument>")
							nil
							hydrogen-swapping-region-beginning
							hydrogen-swapping-region-end))))))
  )

(defun hydrogen-swap-forzeeStereo-and-Flac-GSCW-2 ()
  "Switch from the ForzeeStereo Hydrogen drumkit to the
Flac-GSCW-2 kit.

Please note that this function will only work properly when executed
  in a buffer visiting the .h2song file of a recent (1.0.0*) version
  of the Hydrogen drum computer. "
  (interactive)
  (hydrogen-swap-instruments-non-interactive "2" "12" nil)
  (hydrogen-swap-instruments-non-interactive "11" "18" nil)
  (hydrogen-swap-instruments-non-interactive "17" "9" nil)
  (hydrogen-swap-instruments-non-interactive "20" "7" nil)
  (hydrogen-swap-instruments-non-interactive "1" "11" nil)
  (hydrogen-swap-instruments-non-interactive "4" "1" nil)
  (hydrogen-swap-instruments-non-interactive "13" "15" 1)
  (hydrogen-swap-instruments-non-interactive "14" "13" nil)
  (hydrogen-swap-instruments-non-interactive "3" "14" nil))

(defun hydrogen-swap-gmkit-and-forzeeStereo ()
  "Please use with caution. Legacy and not tested recently."
  (interactive)
  (hydrogen-swap-instruments-non-interactive "5" "1" nil)
  (hydrogen-swap-instruments-non-interactive "7" "2" nil)
  (hydrogen-swap-instruments-non-interactive "9" "3" nil)
  (hydrogen-swap-instruments-non-interactive "6" "11" nil)
  (hydrogen-swap-instruments-non-interactive "10" "11" nil)
  (hydrogen-swap-instruments-non-interactive "13" "17" nil)
  (hydrogen-swap-instruments-non-interactive "14" "13" nil))

(defun hydrogen-swap-lamkit-and-forzeeStereo ()
  "Please use with caution. Legacy and not tested recently."
  (interactive)
  (hydrogen-swap-instruments-non-interactive "5" "20" nil)
  (hydrogen-swap-instruments-non-interactive "6" "17" nil)
  (hydrogen-swap-instruments-non-interactive "7" "13" nil)
  (hydrogen-swap-instruments-non-interactive "8" "14" nil)
  (hydrogen-swap-instruments-non-interactive "1" "4" 1)
  (hydrogen-swap-instruments-non-interactive "2" "4" nil)
  (hydrogen-swap-instruments-non-interactive "11" "1" nil)
  (hydrogen-swap-instruments-non-interactive "10" "2" nil)
  (hydrogen-swap-instruments-non-interactive "3" "11" 1)
  (hydrogen-swap-instruments-non-interactive "4" "11" nil)
  (hydrogen-swap-instruments-non-interactive "9" "3" nil))

;;
;;; End of hydrogen.el
