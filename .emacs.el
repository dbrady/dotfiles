;;; David Brady's Emacs Initialization File

(setq elisp-directory (expand-file-name "~/.elisp"))
(setq package-directory (concat elisp-directory "/packages"))
(setq ini-directory (concat elisp-directory "/ini"))
(setq load-path (cons ini-directory load-path))
(add-to-list 'load-path ini-directory)
(add-to-list 'load-path package-directory)
(add-to-list 'load-path (concat package-directory "/abedra-dot-emacs"))

;;(load "essential")

;; ======================================================================
;; Emacs 24 TODO: (Note: I've largely given up on emacs 24 and gone
;; back to Aquamacs. Mostly due to scratch-buffer saving hassles.)
;;
;; [x] Make emacs open *scratch* at startup instead of the frickin'
;;     splash screen.
(setq inhibit-splash-screen t)
;; [ ] When I run "open -a Emacs.app <file>", open it in a new tab in
;;     the current window. Do not open a new window.

;; [ ] Hide tool-bar by default

;; [ ] Allow C-x C-s to save *scratch* to scratch buffer (w/o changing
;;     buffer-name). I can think of one way to do it--globally change
;;     C-x C-s to call a custom function like save-buffer-dwim that
;;     checks the buffer name. If it's *scratch*, it invokes
;;     save-persistent-scratch but if not it calls the regular
;;     save-buffer. This seems hacky to change ALL of C-x C-s across
;;     emacs, but I'm not sure emacs can hook a keybinding in a single
;;     buffer, can it? I think it can only hook in a given mode, and
;;     while *scratch* always starts out in lisp-interaction, it can
;;     change modes and I wouldn't want to lose this functionality. If
;;     it does become necessary to globally hook C-x C-s, can this be
;;     done cleanly with a defadvice or similar?

;; [ ] Make tabbar show ALL tabs in a single bar. Back in my terminal
;;     days I loved how it kept .php files in a separate bar from .css
;;     files but now I think of all my open buffers as a single thing.
;;     The only possible exception I can think of might be to keep all
;;     system buffers (*help*, *messages*, etc--but NOT *scratch*!) in
;;     one tabbar and all my open buffers (plus *scratch*) in another.
(require 'tabbar)
(tabbar-mode 1)
;; (defun tabbar-buffer-groups ()
;;   "Return the list of group names the current buffer belongs to.
;;  This function is a custom function for tabbar-mode's tabbar-buffer-groups.
;;  This function group all buffers into 3 groups:
;;  Those Dired, those user buffer, and those emacs buffer.
;;  Emacs buffer are those starting with “*”."
;;   (list
;;    (cond
;;     ((string-equal "*" (substring (buffer-name) 0 1))
;;      '("Emacs Buffer")
;;      )
;;     ((eq major-mode 'dired-mode)
;;      '("Dired")
;;      )
;;     (t
;;      '("User Buffer")
;;      )
;;     ))) ;; from Xah Lee
;; (setq tabbar-buffer-groups-function 'tabbar-buffer-groups)

;; [ ] Fix recentf-mode

;; [ ] Fix open-from-cli script

;; [ ] Not sure this is even possible: Make Cmd-+ and Cmd-- enlarge
;;     and reduce the face size in the current buffer. OK if it
;;     enlarges for all buffers visiting that file or even all
;;     buffers in that mode but ideally it should only enlarge for
;;     the current buffer.

;; End Emacs 24 Todo
;; ======================================================================

(defun length-of-line ()
  "Returns length of the current line in characters"
  (length (current-line-string)))

(defun length-of-previous-line ()
  "Returns length of line above point in characters"
  (save-excursion
    (previous-line)
    (length-of-line)))

(defun length-of-first-nonempty-line-above-point ()
  "Returns length of first nonempty line abovee point in characters. Differs from length-of-line-dwim in that it does not consider the length of the current line."
  (save-excursion
    (previous-line)
    (let ((len (length-of-line)))
      (if (or
           (> len 0)
           (= (current-line) 1))
          len
        (length-of-first-nonempty-line-above-point)))))

(defun length-of-line-dwim ()
  "Returns length of the first nonempty line at or above point in characters."
  (let ((len (length-of-line)))
    (if (> len 0)
        len
      (length-of-first-nonempty-line-above-point))))

(defun display-length-of-line ()
  "Displays the length of the current line; if the current line is empty it displays the length of the line above point"
  (interactive)
  (save-excursion
    (let ((len (length-of-line)))
      (if (= len 0)
          (message "Length of first nonempty line above point: %d" (length-of-line-dwim))
        (message "Length of line: %d" (length-of-line-dwim))))))

(global-set-key (kbd "\C-c C-l") 'display-length-of-line)


; ----------------------------------------------------------------------
; CEDET
;; Load CEDET
(load-file (expand-file-name "~/.elisp/packages/cedet/common/cedet.el"))

;; Enabling various SEMANTIC minor modes.  See semantic/INSTALL for more ideas.
;; Select one of the following:

;; * This enables the database and idle reparse engines
;;(semantic-load-enable-mintimum-features)

;; * This enables some tools useful for coding, such as summary mode
;;   imenu support, and the semantic navigator
(semantic-load-enable-code-helpers)

;; * This enables even more coding tools such as the nascent intellisense mode
;;   decoration mode, and stickyfunc mode (plus regular code helpers)
;; (semantic-load-enable-guady-code-helpers)

;; * This turns on which-func support (Plus all other code helpers)
  ;; (semantic-load-enable-excessive-code-helpers)

;; This turns on modes that aid in grammar writing and semantic tool
;; development.  It does not enable any other features such as code
;; helpers above.
;; (semantic-load-enable-semantic-debugging-helpers)
; End CEDET
; ----------------------------------------------------------------------

; ----------------------------------------------------------------------
; ECB
; These lines are required for ECB
;
; YOU PROBABLY DO NOT WANT TO CUSTOMIZE ECB OPTIONS IN HERE! Read the
; ECB info page, it has full docco on options customizable with
; customize-group/customize-option, AND A LIST of options that CANNOT
; BE CHANGED with setq!
;; (add-to-list 'load-path (expand-file-name "~/.elisp/packages/eieio-0.17"))
;; (add-to-list 'load-path (expand-file-name "~/.elisp/packages/speedbar-0.14beta4"))
;; (add-to-list 'load-path (expand-file-name "~/.elisp/packages/semantic-1.4.4"))
(setq semantic-load-turn-everything-on t)
(require 'semantic-load)

; This installs ecb - it is activated with M-x ecb-activate
(add-to-list 'load-path (expand-file-name "~/.elisp/packages/ecb-2.32"))
(require 'ecb-autoloads)
(setq ecb-source-path (quote ((expand-file-name "~/pe/workspace/crimereports"))))
;(setq ecb-source-path (quote ((expand-file-name "~/lmp/degreesearch") (expand-file-name "~/lmp/leadgen") (expand-file-name "~/lmp/market"))))


;(if (jw-check-file "/usr/local/share/emacs/site-lisp")
;    (add-to-load-path "/usr/local/share/emacs/site-lisp") )


;;; Now load all the ini-xxx files in the initialization directory

;; (let ((files (directory-files ini-directory nil "^ini-.*\\.el$")))
;;   (while (not (null files))
;;     (ini-load (substring (car files) 0 -3))
;;     (setq files (cdr files)) ))

;; (message "Initialization Files Loaded")
;; (custom-set-variables
;;  '(init-face-from-resources nil)
;;  '(mm-inline-media-tests (quote (("image/jpeg" mm-inline-image (lambda (handle) (mm-valid-and-fit-image-p (quote jpeg) handle))) ("image/png" mm-inline-image (lambda (handle) (mm-valid-and-fit-image-p (quote png) handle))) ("image/gif" mm-inline-image (lambda (handle) (mm-valid-and-fit-image-p (quote gif) handle))) ("image/tiff" mm-inline-image (lambda (handle) (mm-valid-and-fit-image-p (quote tiff) handle))) ("image/xbm" mm-inline-image (lambda (handle) (mm-valid-and-fit-image-p (quote xbm) handle))) ("image/x-xbitmap" mm-inline-image (lambda (handle) (mm-valid-and-fit-image-p (quote xbm) handle))) ("image/xpm" mm-inline-image (lambda (handle) (mm-valid-and-fit-image-p (quote xpm) handle))) ("image/x-pixmap" mm-inline-image (lambda (handle) (mm-valid-and-fit-image-p (quote xpm) handle))) ("image/bmp" mm-inline-image (lambda (handle) (mm-valid-and-fit-image-p (quote bmp) handle))) ("text/plain" mm-inline-text identity) ("text/enriched" mm-inline-text identity) ("text/richtext" mm-inline-text identity) ("text/x-patch" mm-display-patch-inline (lambda (handle) (locate-library "diff-mode"))) ("application/emacs-lisp" mm-display-elisp-inline identity) ("text/x-vcard" mm-inline-text (lambda (handle) (or (featurep (quote vcard)) (locate-library "vcard")))) ("message/delivery-status" mm-inline-text identity) ("message/rfc822" mm-inline-message identity) ("message/partial" mm-inline-partial identity) ("text/.*" mm-inline-text identity) ("audio/wav" mm-inline-audio (lambda (handle) (and (or (featurep (quote nas-sound)) (featurep (quote native-sound))) (device-sound-enabled-p)))) ("audio/au" mm-inline-audio (lambda (handle) (and (or (featurep (quote nas-sound)) (featurep (quote native-sound))) (device-sound-enabled-p)))) ("application/pgp-signature" ignore identity) ("multipart/alternative" ignore identity) ("multipart/mixed" ignore identity) ("multipart/related" ignore identity))))
;;  '(load-home-init-file t t)
;;  '(gnuserv-program (concat exec-directory "/gnuserv"))
;;  '(toolbar-news-reader (quote gnus))
;;  '(toolbar-mail-reader (quote gnus))
;;  '(ecb-source-path (quote (((expand-file-name "~/working/rubyforge/rubygems") "RubyGems") ((expand-file-name "~/working/rubyforge/rake") "Rake")))))
;; (custom-set-faces
;;  '(default ((t (:size "12pt" :family "Fixed"))) t))
;; (setq mac-option-modifier 'meta)        ; for aquamacs

;; ============================
;; End of Options Menu Settings

(setq minibuffer-max-depth nil)

;; Beginning of the el4r block:
;; RCtool generated this block automatically. DO NOT MODIFY this block!
;; (add-to-list 'load-path "/opt/local/share/emacs/site-lisp")

;; (add-to-list 'load-path "/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/share/emacs/site-lisp")
;; (require 'el4r)
;; (el4r-boot)

;; End of the el4r block.
;; User-setting area is below this line.

; ----------------------------------------------------------------------
; Ack
(require 'ack)
(global-set-key "\M-A" 'ack)

; ----------------------------------------------------------------------
;; ; Erlang Crap
;; (setq load-path (cons  "/opt/local/lib/erlang/lib/tools-2.6.4/emacs"
;;                        load-path))
;; (setq erlang-root-dir "/opt/local/lib/erlang")
;; (setq exec-path (cons "/opt/local/lib/erlang/bin" exec-path))
;; (require 'erlang-start)

;; ================================================================================
;; dbrady-specific stuff

;; ======================================================================
;; UNIVERSAL SECTION
;; ----------------------------------------------------------------------
;; Hi. This is David Brady. If this is the only section in this .emacs
;; file, this is my "overnight bag" for making emacs work the way I
;; like on machines where I haven't had time to move in fully.
;;
;; This section meant to be copied and pasted as an "emergency minimum"
;; .emacs file to new servers where I don't have time to properly move
;; in. Expect arbitrary OSes, emacs to be running from anywhere (could
;; be in /usr/bin, /usr/local/bin, and on three occasions it has been
;; trapped in ~/emacs/ because I didn't have root on the box--one time
;; I didn't even have make tools and had to build it on a separate
;; machine and upload the binaries to my home folder).
;; ----------------------------------------------------------------------
(require 'font-lock)
(transient-mark-mode 1)
(setq sentence-end-double-space 'nil)

;Allows syntax highlighting to work, among other things
;(global-font-lock-mode 1)
(global-set-key (kbd "\C-c C-c C-f") 'font-lock-mode)

;; Do civilized backup names.  Added by dbrady 2003-03-07, taken from
;; http://emacswiki.wikiwikiweb.de/cgi-bin/wiki.pl?BackupDirectory
(setq
 backup-by-copying t         ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/saves"))        ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)          ; use versioned backups

(global-set-key "\M-g" 'goto-line)
(setq-default c-basic-offset 2)
(setq-default sh-basic-offset 2)
(setq-default indent-tabs-mode nil)
;(setq-default indent-tabs-mode t)
(setq default-tab-width 2)

;;----------------------------------------------------------------------
;; column number mode - show current column number
(column-number-mode t)

;; ----------------------------------------------------------------------
;; END UNIVERSAL SECTION
;; ======================================================================

; ----------------------------------------------------------------------
; Use system trash can when deleting files
(setq delete-by-moving-to-trash t)

(setq semanticdb-default-save-directory "~/.saves/semantic.cache")

;; Detect this OS and set keybindings accordings. Ideally this should
;; depend on window settings, but I'm not sure how to make linux
;; understand that I have a Command key.
;;(defvar mswindows-p (string-match "windows" (symbol-name system-type)))
;;(defvar macosx-p (string-match "darwin" (symbol-name system-type)))

;; Actually, it's a bit trickier than this currently. I have blind
;; carbon emacs at the command-line that lacks all of the macosx
;; stuff, and so osxkeys doesn't work.
;;
;; TODO: FIX THIS. It's all smelly and poopy and stuff. The way I
;; currently use this is to map keys to the Command key versus the
;; LWindows key. This is KEYBOARD functionality, not operating-system
;; functionality! Furthermore, when you ssh or xterm into a remote
;; machine, your local keys (like Command!) might actually be
;; available on the remote system even though it doesn't have that
;; key.
;;
;; In other words, don't ask me for the window-system and give me back
;; a keyboard layout.
;;
;; NOTE TO SELF: IT IS AN ACCEPTABLE HACK to write a tiny config file
;; indicating the host os and keyboard mappings, e.g. Linux vs. Mac
;; vs. Windows and Command vs. LWindows.
;;
;; Since I care more about keyboard geometry than labeling (I always
;; map Command to WinKey rather than Ctrl, for example) I wonder if it
;; would hurt anything to just always map the Command and LWin keys on
;; all emacsen that I touch. Right now this would fail because
;; Aquamacs defines the osxkeys in its own internals. I could easily
;; steal those, however, and define them on any system if they are not
;; already present. Assuming they do not cause collisions, this might
;; work.
(defvar mswindows-p (string-match "nil" (symbol-name window-system)))
(defvar macosx-p (string-match "mac" (symbol-name window-system)))


;; Or perhaps I should even learn to hack onto the Windows key... (oooh.)

;; ----------------------------------------------------------------------
;; Macros!

;; ----------------------------------------------------------------------
;; cucumber-align-table
;;
;; With this region selected:
;;  | a | abcd | b |
;;  | aou | ab | ddddd |
;;
;; Spits out:
;;  | a   | abcd | b     |
;;  | aou | ab   | ddddd |
(fset 'cucumber-align-table
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([21 134217852 126 47 46 101 108 105 115 112 47 115 99 114 105 112 116 115 47 99 117 99 117 109 98 101 114 95 97 108 105 103 110 95 116 97 98 108 101 46 114 98 return] 0 "%d")) arg)))
(global-set-key (kbd "\C-c |") 'cucumber-align-table)

;; ----------------------------------------------------------------------
;; function: save-macro
;;
;; Taken from http://www.emacswiki.org/cgi-bin/wiki/KeyboardMacrosTricks
;; TODO: I don't want my macros saved at the end of .emacs.
;;
;; Study: This emits a much different macro version than the version I
;; get when I save a keyboard macro. Instead of simply fsetting the
;; keystrokes, it fsets a lambda that executes
;; kmacro-exec-ring-item. WAY weird! How does it work, and why is it
;; different?
;;
;; Refactor: change this to seek out an insert token in this file, and
;; insert before it.
;;
;; Refactor: (might be easier) create a file for macros and have this
;; function write them there. E.g. .elisp/dave_macros.el
(defun save-macro (name)
  "save a macro. Take a name as argument and save the last defined macro under this name at the end of your .emacs"
  (interactive "SName of the macro :") ; ask for the name of the macro
  (kmacro-name-last-macro name)      ; use this name for the macro
  (find-file "~/.emacs")             ; open the .emacs file
  (goto-char (point-max))            ; go to the end of the .emacs
  (newline)                          ; insert a newline
  (insert-kbd-macro name)            ; copy the macro
  (newline)                          ; insert a newline
  (switch-to-buffer nil))            ; return to the initial buffer

;; ----------------------------------------
;; TODO:
;; - Port this to elisp
;; - Save and restore the x-position of point
;; - Find universal keybindings. I may not always be on a mac when I
;;   want to run this macro! (Okay to figure out how to bind the
;;   Windows key to be logically equivalent here.)
;;
;; This doesn't actually work, but it's a start.
;; (defun move-line-up
;;     (let (columns (- (point) (point-at-bol)))
;;       (move-beginning-of-line)
;;       (transpose-lines)
;;       (previous-line 2)
;;       (forward-char columns)))


;; BORKED! Why doesn't this work anymore? The macro is being defined
;; just  fine, but A-S-p is being mapped to A-p, which inserts the
;; paragraph symbol. When I wrote this macro yesterday, A-S-p was
;; unmapped and undefined. What gives?
(fset 'move-line-up
   "\C-a\C-x\C-t\C-p\C-p")
(if macosx-p
    (global-set-key (vector  `(,osxkeys-command-key shift p))
                    'move-line-up))

;; ----------------------------------------
;; TODO:
;; - Port this to elisp
;; - Save and restore the x-position of point
;; - indent both lines appropriately
(fset 'move-line-down
   "\C-a\C-n\C-x\C-t\C-p")
(if macosx-p
    (global-set-key (vector  `(,osxkeys-command-key shift n))
                    'move-line-down))

;; kill-line-and-replace-with-previous-yank
;; So my old Windows habits die hard. I like to yank the src into the
;; kill ring, then go find the line I want to overwrite. I kill that
;; line with C-k, and want to paste the previous yank, but it's moved
;; up in the kill ring. Not sure this is worthy of a macro and its own
;; keybinding, since the macro is C-c y and all it's replacing is just
;; C-k C-y M-y.
(fset 'kill-line-and-replace-with-previous-yank
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([33554443 33554457 134217817] 0 "%d")) arg)))
(global-set-key (kbd "\C-c y") 'kill-line-and-replace-with-previous-yank)

;; delete-other-window
;; WRITE ME! This is tricksy, because ideally I'd like to take C-u arg
;; and delete THAT window. For now, all I really want is the ability
;; to delete the window on the other side of the split. For now I
;; guess I can make separate macros for delete-next-window and
;; delete-previous-window, which are the two that I would be using
;; nomally anyway.

;; Moves to next window, deletes it, then moves back to the window you
;; were originally in.
(fset 'delete-next-window
      "\C-xo\C-x0\C-u-1\C-xo")
(global-set-key (kbd "\C-x C-0") 'delete-next-window)

;; Moves back to previous window, then deletes it, returning point to
;; the window you were originally in.
(fset 'delete-previous-window
      "\C-u-1\C-xo\C-x0")
(global-set-key (kbd "\C-x M-0") 'delete-previous-window)

;; Turns the leading - into a x, then finds the [.....] block and
;; marks off one period. Results are well-defined but no less
;; interesting if you do not have - at the beginning of the line or if
;; the [.....] block is already full of x's.
(fset 'fivethings-mark-item-completed
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([67108896 67108896 1 19 45 13 backspace 120 18 102 105 118 101 32 116 104 105 110 103 115 32 116 111 32 100 111 32 116 111 100 97 121 32 13 134217830 134217830 134217830 134217830 134217830 6 6 19 46 13 backspace 120 21 67108896 21 67108896 21 67108896 21 67108896] 0 "%d")) arg)))
(global-set-key (kbd "\C-c x") 'fivethings-mark-item-completed)

;; We have a lot of XSD that has to be validated based on current
;; inventory in our database. This is a shoveling tool. Run a select
;; query, such as "SELECT interface_name FROM study_areas", then paste
;; the results into the xsd, rows of text like "| associates |". Then
;; run this macro on each line of text to turn it into an xsd
;; enumeration, e.g. "<xs:enumeration value="associates" />". This
;; really wants to be replaced with an erb template, but for now, meh.
(fset 'xsd-convert-sql-column-to-enumeration
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([1 4 4 5 134217826 134217830 11 1 tab 60 120 115 58 101 110 117 109 101 114 97 116 105 111 110 32 118 97 108 117 101 61 34 5 34 32 47 62 14 1] 0 "%d")) arg)))
;; THIS SHOULD ONLY BE BOUND TO XSD MODE!!! But I'm ignorant. And
;; lazy. Don't forget lazy. So I'm setting it globally for now.
(global-set-key (kbd "\C-c C-c e") 'xsd-convert-sql-column-to-enumeration)


;; ...put cursor after the ) and eval with C-x, C-e
(defvar working-for "Shiny Systems LLC" "*A string identifying who I'm working for. Used in the function comment-file.")
(defvar copyright-since "2002" "*A string containing the beginning year for the copyright line.")

;; Evaluate the appropriate lines here to set up the copyright info as desired.
;; (setq working-for "Shiny Systems LLC")
(defun working-for-shiny ()
  (interactive)
  (setq working-for "Shiny Systems LLC")
  (setq copyright-since "2002"))

(defun working-for-lmp ()
  (interactive)
  (setq working-for "Lead Media Partners LLC")
  (setq copyright-since "2007"))

(defun working-for-pe()
  (interactive)
  (setq working-for "Public Engines Inc")
  (setq copyright-since "2010"))

(working-for-pe)

; Graciously provided by ams on irc.freenode.net:#emacs
; Returns starting point of match if found, else nil
(defun string-ends-with (regexp string)
  (string-match (concat regexp "$") string))

; Returns 0 if true, else nil
(defun string-starts-with (regexp string)
  (string-match (concat "^" regexp) string))

(defun ensure-trailing-space (string)
  (if (string-ends-with " " string)
      string
      (concat string " ")))

(defun ensure-leading-space (string)
  (if (string-starts-with " " string)
      string
      (concat " " string)))

(defun safe-string (value default-value)
  (if (or (null value)
          (string= "" value))
      default-value
    value))

(defun safe-comment-start ()
  (ensure-trailing-space
   (safe-string comment-start "# ")))

(defun safe-comment-end ()
  (safe-string comment-end ""))

;;----------------------------------------------------------------------
;; make-section-heading
;; Turns uppercases the current line and surrounds it with ===='s
(defun make-section-heading ()
  (interactive)
  (save-excursion
    (upcase-region (point-at-bol) (point-at-eol)))
  (beginning-of-line)
  (insert (safe-comment-start))
  (end-of-line)
  (insert "\n" (safe-comment-start) "======================================================================" (safe-comment-end))
  (beginning-of-line)
  (previous-line 2)
  (end-of-line)
  (insert "\n" (safe-comment-start) "======================================================================")
  (beginning-of-line)
  (forward-line 3))

;;----------------------------------------------------------------------
;; make-minor-heading
;; Turns uppercases the current line and surrounds it with ===='s
(defun make-minor-heading ()
  (interactive)
  (save-excursion
    (upcase-region (point-at-bol) (point-at-eol)))
  (beginning-of-line)
  (insert (safe-comment-start))
  (end-of-line)
  (insert "\n" (safe-comment-start) "----------------------------------------------------------------------" (safe-comment-end))
  (beginning-of-line)
  (previous-line 2)
  (end-of-line)
  (insert "\n" (safe-comment-start) "----------------------------------------------------------------------" (safe-comment-end) "\n"))

;;----------------------------------------------------------------------
;; insert-comment-nop
(defun insert-comment-nop ()
  (interactive)
  (insert (safe-comment-start) ";-) (Happy little no-op)" (safe-comment-end))
  (indent-region (point-at-bol) (point-at-eol) nil))

;;----------------------------------------------------------------------
;; insert-comment-nop-function-body
(defun insert-comment-nop-function-body ()
  (interactive)
  (let ((start (point)))
    (insert "{\n" (safe-comment-start) ";-) (Happy little no-op)" (safe-comment-end) "\n}\n")
    (indent-region start (point) nil)))

;;----------------------------------------------------------------------
;; insert-comment-bar
(defun insert-comment-bar ()
  (interactive)
  (insert (safe-comment-start) "----------------------------------------------------------------------" (safe-comment-end) "\n"))

;;----------------------------------------------------------------------
;; insert-comment-bar-major
(defun insert-comment-bar-major ()
  (interactive)
  (insert (safe-comment-start) "======================================================================" (safe-comment-end) "\n"))

;;----------------------------------------------------------------------
;; insert-danger-banner
;; TODO: If C-u N passed, send that many lines
;; TODO: Indent this after inserting
(defun insert-danger-banner ()
	(interactive)
	(insert (safe-comment-start) "DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER\n")
	(insert (safe-comment-start) " DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGE\n")
	(insert (safe-comment-start) "R DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANG\n")
	(insert (safe-comment-start) "ER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DAN\n")
	(insert (safe-comment-start) "GER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DA\n")
	(insert (safe-comment-start) "NGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER D\n")
	(insert (safe-comment-start) "ANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER \n")
	(insert (safe-comment-start) "DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER\n")
)

;;----------------------------------------------------------------------
;; insert-danger-banner-reverse
;; TODO: Refactor me! Change me to (reverse-lines (insert-danger-banner N))
(defun insert-danger-banner-reverse ()
	(interactive)
	(insert (safe-comment-start) "DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER\n")
	(insert (safe-comment-start) "ANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER \n")
	(insert (safe-comment-start) "NGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER D\n")
	(insert (safe-comment-start) "GER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DA\n")
	(insert (safe-comment-start) "ER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DAN\n")
	(insert (safe-comment-start) "R DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANG\n")
	(insert (safe-comment-start) " DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGE\n")
	(insert (safe-comment-start) "DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER DANGER\n")
)


;;----------------------------------------------------------------------
;; html functions
(defun insert-table-declaration ()
    (interactive)
    (save-excursion
        (insert "<table border=\"0\" cellpadding=\"3\" cellspacing=\"0\">\n")
        (insert "    <tr>\n")
        (insert "        <td>\n")
        (insert "        </td>\n")
        (insert "    </tr>\n")
        (insert "</table>\n")))

(defun insert-table-row ()
    (interactive)
    (save-excursion
        (insert "    <tr>\n")
        (insert "        <td>\n")
        (insert "        </td>\n")
        (insert "    </tr>\n")))

;; (global-set-key (kbd "\C-c d") 'document-function)
;; (global-set-key (kbd "\C-c x") 'doxygenate-function)
;; (global-set-key (kbd "\C-c M-t") 'insert-table-declaration)
;; (global-set-key (kbd "\C-c M-r") 'insert-table-row)

;; (global-set-key (kbd "\C-c C-s") 'make-section-heading)
;; (global-set-key (kbd "\C-c s") 'make-minor-heading)
(global-set-key (kbd "\C-c -") 'insert-comment-bar)
(global-set-key (kbd "\C-c =") 'insert-comment-bar-major)
;; (global-set-key (kbd "\C-c ;") 'insert-comment-nop)
;; (global-set-key (kbd "\C-c :") 'insert-comment-nop-function-body)

;; Aquamacs puts comment-region on C-#; need to check other emacsen or else force it here
;; Aquamacs doesn't put uncomment-region on any key, which seems dumb.
;; (global-set-key [?\M-\C-#] 'uncomment-region)

;; Bind C-c M-f to auto-fill-mode.
(global-set-key (kbd "\C-c M-f") 'auto-fill-mode)

;;----------------------------------------------------------------------
;; comment-name-and-date
;; Inserts a comment string, login name, date, and a colon.
;; Example: // dbrady 2003-04-05:
;; TODO! If prefix-arg is present, include the time. So:
;; C-c /        => ; dbrady 2008-06-08:
;; C-u C-c /    => ; dbrady 2008-06-08 13:51:25:
(defun comment-name-and-date ()
  (interactive)
  (insert (safe-comment-start) user-login-name " " (format-time-string "%Y-%m-%d") ": " (safe-comment-end)))

(defun insert-date ()
  (interactive)
  (insert (format-time-string "%Y-%m-%d")))
(global-set-key (kbd "\C-c @") 'insert-date)

;;----------------------------------------------------------------------
;; insert-five-things
;; Inserts an org-mode text snippet for "Five Things To Do Today".
;; TODO: See about hooking Org-mode snippets.
;; TODO: Refactor inserts to a loop?
(defun insert-five-things ()
  (interactive)
  (insert "* " (format-time-string "%Y-%m-%d") "\n")
  (insert "** Five Things To Do Today [0/5]\n")
  (insert "- [ ] \n")
  (insert "- [ ] \n")
  (insert "- [ ] \n")
  (insert "- [ ] \n")
  (insert "- [ ] \n")
  (previous-line)(previous-line)(previous-line)(previous-line)(previous-line)(end-of-line))
;; TODO: this should be an org-mode-only hook
(global-set-key (kbd "\C-c 5") 'insert-five-things)

;;----------------------------------------------------------------------
;; comment-file
;; Adds a comment block at the top of the file
;;
;; TODO - Figure out how to put this AFTER the <?php tag in a php
;; file.
(defun comment-file ()
  (interactive)
  (beginning-of-buffer)
  (insert (safe-comment-start) "----------------------------------------------------------------------\n")
  (insert (safe-comment-start) " Name: " (buffer-name) "\n")
  (insert (safe-comment-start) " Desc: \n")
  (insert (safe-comment-start) " Auth: " user-login-name "\n")
  (insert (safe-comment-start) " Date: " (format-time-string "%Y-%m-%d") "\n")
  (insert (safe-comment-start) " Copyright (C) " copyright-since (format-time-string "-%Y ") working-for " \n")
  (insert (safe-comment-start) "----------------------------------------------------------------------" (safe-comment-end) "\n")
)

(global-set-key (kbd "\C-c C-f") 'comment-file)

; ----------------------------------------------------------------------
; reload-buffer
; Seriously, why doesn't this already exist? Reloads the current
; buffer.  find-alternate-file will sort of already do this; if you do
; not supply an argument to it it will reload the current
; buffer... but it will switch you to another buffer when it does
; it. All this function does is find-alt and then switch you back.
;
; TODO: This breaks down when you have multiple buffers containing the
; same file basename, e.g. app/models/user.rb and spec/models/user.rb
; because one of the buffers will have the buffername "user.rb (2)".
; The buffer will be reloaded correctly but won't get switched to. Not
; entirely sure why. Ideally it would be nice to be able to find a
; buffer by the complete pathname it is visiting, as this would remain
; constant and unique.
(defun reload-buffer()
  (interactive)
  (let ((buffername (buffer-name)))
    (find-alternate-file buffername)
    (switch-to-buffer buffername)))
; override the binding for find-alternate-file to be reload-buffer,
; since that's what I always use it for.
(global-set-key (kbd "\C-x C-v") 'reload-buffer)

;;----------------------------------------------------------------------
;; On some systems, I exist as "dbrady" but do a lot of work su'd as
;; the account that owns a chunk of code (vpopmail on 4mykids, admin17
;; on bnt, etc.)  In these cases, I want to use a hardcoded 'dbrady'.
(defun comment-name-and-date-dbrady ()
  (interactive)
  (insert (safe-comment-start) "dbrady " (format-time-string "%Y-%m-%d") ": " (safe-comment-end)))

;;----------------------------------------------------------------------
;; For accounts where I'm su'd, uncomment the *-dbrady version
;; (global-set-key (kbd "\C-c #") 'comment-name-and-date-dbrady)
(global-set-key (kbd "\C-c #") 'comment-name-and-date)

;;----------------------------------------------------------------------
;; Thanks cwyckoff for finding this!
;; toggle to fullscreen mode
;; BLEURKH. This does not work with the Gnu Emacs 23 build. BLAH.
(defun toggle-fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen (if (frame-parameter nil 'fullscreen)
                                           nil
                                           'fullboth)))
(global-set-key (kbd "\C-c C-f") 'toggle-fullscreen)

;;----------------------------------------------------------------------
;; Other Modes I like to use...
;; ;; (add-to-list 'load-path (expand-file-name "~/.elisp/packages/icicles"))

;; ;; (add-to-list 'load-path (expand-file-name "~/.elisp/packages/rspec-mode"))

(add-to-list 'load-path "~/.elisp/packages/coffee-mode")
(autoload 'coffee-mode "coffee-mode")
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))

(autoload 'css-mode "css-mode")
(setq auto-mode-alist
     (cons '("\\.css\\'" . css-mode) auto-mode-alist))

(autoload 'haml-mode "haml-mode")
(autoload 'sass-mode "sass-mode")

(autoload 'markdown-mode "markdown-mode")
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))

(autoload 'php-mode "php-mode" "PHP editing mode" t)
(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc\\'" . php-mode))
(require 'php-mode)


;        (define-key ruby-mode-map "\C-m" 'newline-and-indent) ;Not sure if this line is 100% right!

(autoload 'csv-mode "csv-mode" "CSV editing mode" t)
(add-to-list 'auto-mode-alist '("\\.csv\\'" . csv-mode))


(autoload 'python-mode "python-mode")
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'auto-mode-alist '("\\.mp3\\'" . hexl-mode))

;; this is a problem with rvm--the ruby moves around. Need some kind
;; of rvm-mode that understands that ruby location changes based on
;; buffer location...
;; (setq exec-path (cons (expand-file-name "~/.gem/ruby/1.8/bin") exec-path))
;(autoload 'scss-mode "scss-mode")
(require 'scss-mode) ;; require so we can override scss-compile-at-save
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
(setq scss-compile-at-save nil)

;; fix indentation in css/scss mode
(setq cssm-indent-level 2)
(setq cssm-newline-before-closing-bracket t)
(setq cssm-indent-function #'cssm-c-style-indenter)
(setq cssm-mirror-mode nil)


;; (load "ruby-mode.el") ; manually execute this line if you need to get at ruby-mode without an autoload
(autoload 'ruby-mode "ruby-mode")
(add-to-list 'auto-mode-alist '("\\.rb\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rjs\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rxml\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.builder\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\Vagrantfile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\Gemfile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\Guardfile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.haml\\'" . haml-mode))
(add-to-list 'auto-mode-alist '("\\.sass\\'" . sass-mode))

(autoload 'textile-mode "textile-mode")
(add-to-list 'auto-mode-alist '("\\.textile\\'" . textile-mode))

(autoload 'textile-mode "textile-mode" "Textile editing mode" t)
(add-to-list 'auto-mode-alist '("\\.textile\\'" . textile-mode))

(add-to-list 'auto-mode-alist '("\\.ny\\'" . lisp-mode))

(load "cucumber-mode")

(autoload 'puppet-mode "puppet-mode")
(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))
(add-to-list 'auto-mode-alist '("README$" . text-mode))
(add-to-list 'auto-mode-alist '("TODO$" . text-mode))
(add-to-list 'auto-mode-alist '("CHANGELOG$" . text-mode))
(add-to-list 'auto-mode-alist '("CHANGES$" . text-mode))
(add-to-list 'auto-mode-alist '("LICENSE$" . text-mode))

(setq auto-mode-alist (cons '("\\.lua$" . lua-mode) auto-mode-alist))
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)

;; version 0.0.3; locks up on me.
;;(require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

(autoload 'actionscript-mode "actionscript-mode" t)

(setq auto-mode-alist (append (list
 '("\\.as\\'"   . actionscript-mode)
 '("\\.\\(xml\\|xsl\\|rng\\|xhtml\\|mxml\\)\\'" . nxml-mode)
 ;; add more modes here
 ) auto-mode-alist))

(add-to-list 'auto-mode-alist '("\\.tpl\\'" . html-mode))
(add-to-list 'auto-mode-alist '("\\.rhtml\\'" . html-mode))


; Turn off auto-fill in HTML mode!
(add-hook 'html-mode-hook
          '(lambda ()
             (auto-fill-mode t)
             (auto-fill-mode nil)))

; ----------------------------------------------------------------------
; More ruby mode stuff
; Simple Lisp Files
(add-to-list 'load-path "~/.site-lisp/el")
(require 'pabbrev)

;; Ruby Mode
(add-to-list 'load-path "~/.site-lisp/ruby-mode")

(require 'ruby-mode)

(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook
          '(lambda ()
             (inf-ruby-keys)
             ))

(defun insert-lambda ()
  (interactive)
  (insert "λ"))
(global-set-key (kbd "\C-c C-c C-l") 'insert-lambda)


(add-hook 'ruby-mode-hook
      (lambda()
        (add-hook 'local-write-file-hooks
                  '(lambda()
                     (save-excursion
                       (untabify (point-min) (point-max))
                       (delete-trailing-whitespace)
                       )))
        (set (make-local-variable 'indent-tabs-mode) 'nil)
        (set (make-local-variable 'tab-width) 2)
        (imenu-add-to-menubar "IMENU")
        (define-key ruby-mode-map "\C-m" 'newline-and-indent) ;Not sure if this line is 100% right!
        (require 'ruby-electric)
        (ruby-electric-mode t)
        ))

(add-hook 'html-mode-hook
          (lambda()
            ; disable auto-fill-mode. t ensures it's on, nil toggles it.
            (auto-fill-mode t)
            (auto-fill-mode)))

;; You need to fill in the variables, but once done, this runs
;; script/console on the targeted host and application when you run
;; inf-ruby.

;;
;; (defun rails-remote-console ()
;;   (interactive)
;;   (run-ruby "ssh remotehost /apps/my-app/current/script/console"))

;; (defun ruby-eval-buffer () (interactive)
;;        "Evaluate the buffer with ruby."
;;        (shell-command-on-region (point-min) (point-max) "ruby"))

(defun my-ruby-mode-hook ()
  (setq standard-indent 2)
  ; (pabbrev-mode t)
  ; (ruby-electric-mode t)
  (define-key ruby-mode-map "\C-c\C-a" 'ruby-eval-buffer))
(add-hook 'ruby-mode-hook 'my-ruby-mode-hook)

; (setq auto-mode-alist (cons '("\\.rb\\'" . rhtml-mode) auto-mode-alist))

(autoload 'mode-compile "mode-compile"
   "Command to compile current buffer file based on the major mode" t)
(global-set-key "\C-cc" 'mode-compile)
(autoload 'mode-compile-kill "mode-compile"
 "Command to kill a compilation launched by `mode-compile'" t)
(global-set-key "\C-ck" 'mode-compile-kill)


;; ;; Rinari Mode (Rails)
;; (add-to-list 'load-path "~/.site-lisp/rinari")
;; (add-to-list 'load-path "~/.site-lisp/rinari/rhtml")
;; (require 'rinari)
;; (setq auto-mode-alist (cons '("\\.rhtml\\'" . rhtml-mode) auto-mode-alist))


;; yaml mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-hook 'yaml-mode-hook
 '(lambda ()
  (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;; ----------------------------------------------------------------------
;; ido mode stuff
(require 'ido)
(ido-mode t)

(defun ido-execute ()
  (interactive)
  (call-interactively
   (intern
    (ido-completing-read
     "M-x "
     (let (cmd-list)
       (mapatoms (lambda (S) (when (commandp S) (setq cmd-list (cons (format "%S" S) cmd-list)))))
       cmd-list)))))


(global-set-key [(control meta x)] 'ido-execute)

;; ----------------------------------------------------------------------
;; git.el
(require 'git)

; ----------------------------------------------------------------------
; flyspell
;; (autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)
;; (autoload 'flyspell-delay-command "flyspell" "Delay on command." t)
;; (autoload 'tex-mode-flyspell-verify "flyspell" "" t)

;; some extra flyspell delayed command
;; (mapcar 'flyspell-delay-command	'(scroll-up1 scroll-down1))

; Corrections are sorted alphabetically by default; disable this to
; get sorting by likeness.
;; (setq flyspell-sort-corrections nil)

; Doubled words are considered errors by default. Disable that for now.
;; (setq flyspell-doublon-as-error-flag nil)

;; rdoc mode
(load "rdoc-mode")
(add-to-list 'auto-mode-alist '("\\.rdoc\\'" . rdoc-mode))

;; ======================================================================
;; Experimental
;; ----------------------------------------------------------------------

;; For Carbon Emacs, this will partially unscrew the modifier keys.
;; This sets the option key to be alt/meta and the command key to be
;; the extra/super/meta/whatever key. It still doesn't release Cmd to
;; the OS, however. You can't Cmd-Q or Cmd-V*.
;;
;; * There is a menu option to enable CUA clipboard. This sets
;; Cmd-X,C,V to the clipboard keys, but STILL doesn't release the Cmd
;; keys. Bleh. Going back to Aquamacs for now.
;;
;; (setq mac-command-modifier 'alt
;;       mac-option-modifier 'meta)

;; line-num
(require 'line-num)

;; magit

(require 'magit)
(autoload 'magit-status "magit" nil t)

;; YASnippet
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.elisp/packages/snippets/")

(require 'thingatpt)


(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("sh" . sh-mode))
(add-to-list 'interpreter-mode-alist '("bash" . sh-mode))


;; rdebug
(load-library "rdebug")
(global-set-key "\C-c\C-d" 'rdebug)

; ----------------------------------------------------------------------
; org-mode
;
; setup
;
;; org-mode (manual install of latest overtop of standard (read: old)
;; org-mode that comes with Aquamacs
(setq org-mode-directory (concat package-directory "/org-6.28e"))
(setq load-path (cons (concat org-mode-directory "/lisp") load-path))
(setq load-path (cons (concat org-mode-directory "/contrib/lisp") load-path))
(require 'org-install)

; activation
;; The following lines are always needed.  Choose your own keys.
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key "\C-c\C-t" 'orgtbl-mode)

; org-mode depends on global-font-lock-mode, which is turned on
; elsewhere, but let's enforce it for org-mode buffers anyway:
; (global-font-lock-mode 1)
(add-hook 'org-mode-hook 'turn-on-font-lock)


; customizers
(setq org-todo-keywords
       '((sequence "TODO(t)" "STARTED(s)" "WAITING(w)" "BLOCKED(b)" "|" "DONE(d)" "ABANDONED(a)")))

(setq org-startup-folded nil)

; ----------------------------------------------------------------------
; remember
;
; Note - remember is included in Emacs 23. OK to remove this once
; Aquamacs catches up.
;; (add-to-list 'load-path (concat package-directory "/remember"))
;; (require 'remember)
;; ; planner-mode
;; (require 'remember-planner)
;; (setq remember-handler-functions '(remember-planner-append))
;; ; doesn't work... planner-annotation-functions not yet defined. Check
;; ; org-mode setup for details; it may have come from there.
;; ; (setq remember-annotation-functions planner-annotation-functions)

;; (setq org-directory "~/Documents/orgfiles/")
;; (setq org-default-notes-file "~/Documents/orgfiles/.notes")
;; (setq remember-annotation-functions '(org-remember-annotation))
;; (setq remember-handler-functions '(org-remember-handler))
;; (add-hook 'remember-mode-hook 'org-remember-apply-template)
;; (define-key global-map "\C-cr" 'org-remember)

;; (setq org-remember-templates
;;      '(("Todo" ?t "* TODO %? %^g\n %i\n " "~/Documents/GTD/newgtd.org" "Office")
;;       ("Journal" ?j "\n* %^{topic} %T \n%i%?\n" "~/Documents/GTD/journal.org")
;;       ("Book" ?b "\n* %^{Book Title} %t :READING: \n%[~/Documents/GTD/booktemp.txt]\n"
;;               "~/Documents/GTD/journal.org")
;;       ("Private" ?p "\n* %^{topic} %T \n%i%?\n" "~/Documents/GTD/privnotes.org")
;;       ("Contact" ?c "\n* %^{Name} :CONTACT:\n%[~/Documents/GTD/contemp.txt]\n"
;;                "~/Documents/GTD/privnotes.org")
;;       ))

; ----------------------------------------------------------------------
; ----------------------------------------------------------------------
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; BEGIN ORG-MODE HACKS
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; ----------------------------------------------------------------------
; ----------------------------------------------------------------------
;
; This next bit sets counters in org-mode headlines. You write [/] at
; the end of the line, add some tasks, and when they are checked off
; the headline is updated to end with, e.g. [4/6] or [0/3], etc.
;
; This appears to be included in Emacs 23. Check this when aquamacs
; upgrades.
(defun wicked/org-update-checkbox-count (&optional all)
  "Update the checkbox statistics in the current section.
This will find all statistic cookies like [57%] and [6/12] and update
them with the current numbers.  With optional prefix argument ALL,
do this for the whole buffer."
  (interactive "P")
  (save-excursion
    (let* ((buffer-invisibility-spec (org-inhibit-invisibility))
           (beg (condition-case nil
                    (progn (outline-back-to-heading) (point))
                  (error (point-min))))
           (end (move-marker
                 (make-marker)
                 (progn (or (outline-get-next-sibling) ;; (1)
                            (goto-char (point-max)))
                        (point))))
           (re "\\(\\[[0-9]*%\\]\\)\\|\\(\\[[0-9]*/[0-9]*\\]\\)")
           (re-box
            "^[ \t]*\\(*+\\|[-+*]\\|[0-9]+[.)]\\) +\\(\\[[- X]\\]\\)")
           b1 e1 f1 c-on c-off lim (cstat 0))
      (when all
        (goto-char (point-min))
        (or (outline-get-next-sibling) (goto-char (point-max))) ;; (2)
        (setq beg (point) end (point-max)))
      (goto-char beg)
      (while (re-search-forward re end t)
        (setq cstat (1+ cstat)
              b1 (match-beginning 0)
              e1 (match-end 0)
              f1 (match-beginning 1)
              lim (cond
                   ((org-on-heading-p)
                    (or (outline-get-next-sibling) ;; (3)
                        (goto-char (point-max)))
                    (point))
                   ((org-at-item-p) (org-end-of-item) (point))
                   (t nil))
              c-on 0 c-off 0)
        (goto-char e1)
        (when lim
          (while (re-search-forward re-box lim t)
            (if (member (match-string 2) '("[ ]" "[-]"))
                (setq c-off (1+ c-off))
              (setq c-on (1+ c-on))))
          (goto-char b1)
          (insert (if f1
                      (format "[%d%%]" (/ (* 100 c-on)
                                          (max 1 (+ c-on c-off))))
                    (format "[%d/%d]" c-on (+ c-on c-off))))
          (and (looking-at "\\[.*?\\]")
               (replace-match ""))))
      (when (interactive-p)
        (message "Checkbox statistics updated %s (%d places)"
                 (if all "in entire file" "in current outline entry")
                 cstat)))))

(defadvice org-update-checkbox-count (around wicked activate)
  "Fix the built-in checkbox count to understand headlines."
  (setq ad-return-value
	(wicked/org-update-checkbox-count (ad-get-arg 1))))

(defun wc ()
  (interactive)
  (message "Word count: %s" (how-many "\\w+" (point-min) (point-max))))

;; Stolen from Steve Yegge's .emacs file
(defun swap-windows ()
  "If you have 2 windows, it swaps them."
  (interactive)
  (cond ((/= (count-windows) 2)
         (message "You need exactly 2 windows to do this."))
        (t
         (let* ((w1 (first (window-list)))
                (w2 (second (window-list)))
                (b1 (window-buffer w1))
                (b2 (window-buffer w2))
                (s1 (window-start w1))
                (s2 (window-start w2)))
           (set-window-buffer w1 b2)
           (set-window-buffer w2 b1)
           (set-window-start w1 s2)
           (set-window-start w2 s1))))
  (other-window 1))

;; TODO: This defun needs a much better name!
(defun split-window-right-last-buffer ()
  "Splits window right, but instead of duplicating the current buffer, it opens the last buffer you visited before this one"
  (interactive)
  (cond ((/= (count-windows) 1)
         (message "You need exactly 1 window open to do this."))
        (t
         (split-window-right)
         (let* ((w2 (second (window-list)))
                (b2 (second (buffer-list))))
           (set-window-buffer w2 b2)))))

; ----------------------------------------------------------------------
; ----------------------------------------------------------------------
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; BEGIN ORG-MODE HACKS
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; ----------------------------------------------------------------------
; ----------------------------------------------------------------------


; From Scotty Moon: Here's how to add new key bindings to existing mode.
; ----------------------------------------------------------------------
;(add-hook 'rspec-mode-hook
; (lambda ()
; (define-key rspec-mode-map (kbd "M-s") 'run-focused-spec)
; (define-key rspec-mode-map (kbd "M-S") 'run-specs)
; )

; ======================================================================
; LOOKING FOR SOMETHING?
;
; Not .emacs settings, but you'll come looking here, so... hi.
;
; ----------------------------------------------------------------------
; "jumping cursor" bug. Scrolling up and down with C-p/C-n, the cursor
; jumps whole blocks of text? You need to disable
; global-visual-line-mode. Then ECB will play nice with Aquamacs. Or
; possibly vice-versa. Anyway it fixes it.
;
; M-x customize-variable
; global-visual-line-mode
;
; Aquamacs 1.5 introduced global-visual-line-mode, which currently
; does not play well with semantic/ecb/rails-mode. Disable it by going
; to Options->Customize Emacs->Specific Option... and typing
; global-visual-line-mode in the minibuffer. Set it to nil, save it,
; save for future sessions, and you're good to go.



;; (defun show-mark-begin (beg end)
;;   (interactive "r")
;;   (print beg)
;;   (print end))
;; (global-set-key "\C-c(" 'show-mark-begin)


; ======================================================================
; Last but not least: automatic settings updates from emacs. It sticks
; them here at the end; Easier to just mark this section as emacs'
; section rather than trying to fight it and keep this updated alla
; time.
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled t)

;; ----------------------------------------------------------------------
;; Experimental -- code from Tim Harper to add checkbox to org-mode
;; when hitting M-enter in a checklist

(defadvice org-insert-item (before org-insert-item-autocheckbox activate)
  (save-excursion
    (org-beginning-of-item)
    (when (org-at-item-checkbox-p)
      (ad-set-args 0 '(checkbox)))))

;;if you auto-load emacs... this will patch org-mode after it loads:
(eval-after-load "org-mode"
  '(defadvice org-insert-item (before org-insert-item-autocheckbox activate)
     (save-excursion
       (when (org-at-item-p)
         (org-beginning-of-item)
         (when (org-at-item-checkbox-p)
           (ad-set-args 0 '(checkbox)))))))


;; 1:59 err.. auto-load org-mode

;; ----------------------------------------------------------------------
;; Experimental -- code from Tim Harper to add checkbox to org-mode
;; when hitting M-enter in a checklist

(defadvice org-insert-item (before org-insert-item-autocheckbox activate)
  (save-excursion
    (org-beginning-of-item)
    (when (org-at-item-checkbox-p)
      (ad-set-args 0 '(checkbox)))))

;;if you auto-load emacs... this will patch org-mode after it loads:
(eval-after-load "org-mode"
  '(defadvice org-insert-item (before org-insert-item-autocheckbox activate)
     (save-excursion
       (when (org-at-item-p)
         (org-beginning-of-item)
         (when (org-at-item-checkbox-p)
           (ad-set-args 0 '(checkbox)))))))


;; 1:59 err.. auto-load org-mode

;; ----------------------------------------------------------------------
;; mediawiki mode!
(require 'mediawiki)

;; ----------------------------------------------------------------------
;; refactoring-split-temporary-variable
;; Given:
;; - Region around an expression; (ideally: point in a line with an
;;   expression that could then be extracted?)
;;
;; Do:
;; - Prompt for temporary variable name
;; - TODO: For statically typed langs, prompt for variable type, or
;;   perhaps accept a space in the variable name?
;; - Cut region
;; - insert temporary variable name
;; - go up a line and insert variable = yank expression
;;
;; Example:
;;    extrapolate(find_shapes())
;; # region around "find_shapes()"
;; # temporary-variable-name: shapes
;; # =>
;;    shapes = find_shapes
;;    extrapolate(shapes)

;; ----------------------------------------------------------------------
;; refactoring-inline-temporary-variable
;; Given:
;; - Point on a line declaring a temporary variable
;;
;; Do:
;; - Parse the line, expecting [vartype] temp_var = expression
;; - Expand region to full current scope
;; - Replace temp_var with expression in region
;; - Delete the original line
;;
;; Example:
;;    shapes = find_shapes()
;;    extrapolate(shapes)
;;    log_data(shapes)
;; # Point is on shapes = find_shapes() line
;; # refactoring-inline-temporary-variable
;; # =>
;;    extrapolate(find_shapes())
;;    log_data(find_shapes())

;; ----------------------------------------------------------------------
;; refactoring-change-variable-to-java-case
;; ((select-symbol-at-pt)
;;  (narrow-to-region)
;;  (replace-regexp "_\(.\)" "\,(upcase \1)")
;;  (widen))


;; Note: This is unreadable in dark themes with white text. Need to find a way to set the face color to black of the highlighted line
(add-hook 'find-file-hooks '(lambda () (highlight-lines-matching-regexp "\\(FIXME\\|TODO\\|BUG\\):" 'hi-yellow-b)))

; ----------------------------------------------------------------------
; Experimental - code from @dotemacs on Twitter to delete current file
(defun kill-current-buffer-and-delete-file (buf)
	(interactive "b")
	(delete-file (buffer-file-name))
	(kill-buffer (buffer-name)))

(add-hook 'after-save-hook
  'executable-make-buffer-file-executable-if-script-p)

(add-hook 'before-save-hook
  'delete-trailing-whitespace)

; ----------------------------------------------------------------------
; recentf tweaks
; (require 'recentf)

;; enable recent files mode.
; (recentf-mode t)

(setq recentf-max-saved-items 50)

(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))

;; get rid of `find-file-read-only' and replace it with something
;; more useful.
; (global-set-key (kbd "C-x C-r") 'ido-recentf-open)


; ----------------------------------------------------------------------
; espresso-mode (for javascript)
(autoload #'espresso-mode "espresso" "Start espresso-mode" t)
(add-to-list 'auto-mode-alist '("\\.js.erb$" . espresso-mode))
(add-to-list 'auto-mode-alist '("\\.js$" . espresso-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . espresso-mode))

(defun my-espresso-mode-hook ()
  (setq espresso-indent-level 2)
  (define-key espresso-mode-map "\C-c /" 'comment-dwim))
(add-hook 'espresso-mode-hook 'my-espresso-mode-hook)


; dbrady 2008-07-14: I don't like how these keep moving around. Plz
; find permanent home for dem kthxbai. ALSO! I dun like C-c # b/c it's
; Left-Control C, Right-Shift 3. It's a 4-keypress "X" where my hands
; have to do a "/" pattern followed by a "\" pattern. Make sense? Try
; typing it a few times. (Qwerty users: C-c in Dvorak is where your
; C-i would be. Also, what are you doing in my .emacs file? Geroff! Go
; on, git!)
;; (global-set-key (kbd "\C-c /") 'comment-region)
;; (global-set-key (kbd "\C-c C-c /") 'uncomment-region)
(global-set-key (kbd "\C-c /") 'comment-dwim)




(require 'linum)
; DO NOT ENABLE LINUM MODE GLOBALLY!
; linum crashes org-mode. Happily, org-mode overrides C-c l.
; org mode appears to have seized this all round. What gives?
(global-set-key "\C-c l" 'linum-mode)

; ok to use mode hooks to auto-enable linum-mode, though
(defun enable-linum-mode ()
  (linum-mode t))
(add-hook 'c-mode-hook 'enable-linum-mode)
(add-hook 'csv-mode-hook 'enable-linum-mode)
(add-hook 'emacs-lisp-mode-hook 'enable-linum-mode)
(add-hook 'coffee-mode-hook 'enable-linum-mode)
(add-hook 'feature-mode-hook 'enable-linum-mode)
(add-hook 'java-mode-hook 'enable-linum-mode)
(add-hook 'espresso-mode-hook 'enable-linum-mode)
(add-hook 'haml-mode-hook 'enable-linum-mode)
(add-hook 'lisp-mode-hook 'enable-linum-mode)
(add-hook 'nxml-mode-hook 'enable-linum-mode)
(add-hook 'php-mode-hook 'enable-linum-mode)
(add-hook 'ruby-mode-hook 'enable-linum-mode)
(add-hook 'sass-mode-hook 'enable-linum-mode)
(add-hook 'scss-mode-hook 'enable-linum-mode)
(add-hook 'sh-mode-hook 'enable-linum-mode)
(add-hook 'text-mode-hook 'enable-linum-mode)
(add-hook 'textile-mode-hook 'enable-linum-mode)
(add-hook 'xml-mode-hook 'enable-linum-mode)
(add-hook 'yaml-mode-hook 'enable-linum-mode)


;; ----------------------------------------------------------------------
;; nodify-commas
;;
;; In Node.js, the common idiom is to NOT leave hanging commas at the
;; end of lines, but to begin the NEXT line with the comma. This is
;; because JavaScript is very tetchy about commas. This macro searches
;; for a comma at the end of a line and moves it to the beginning of
;; the line following.
(fset 'nodify-commas
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([134217848 115 101 97 114 99 104 45 102 tab 45 114 tab return 44 36 backspace 91 91 58 115 112 97 99 101 58 93 93 42 36 return backspace 14 1 134217837 44 32] 0 "%d")) arg)))

;; ======================================================================

;; Tim Harper  (http://github.com/timcharper) is responsible for writing this code, for better or for worse.
;; CamelCase related behavior

(require 'thingatpt)

(defun textmate-case/camelCase-p (word)
  (let (case-fold-search)
    (and (not (string-match "_" word))
         (not (string-match "^[A-Z]" word)))))

(defun textmate-case/snake_case-p (word)
  (string-match "_" word))

(defun textmate-case/PascalCase-p (word)
  (let (case-fold-search)
    (and (not (string-match "_" word))
         (string-match "^[A-Z]" word))))

(defun textmate-case/word-pieces (word)
  "returns a list of the pieces of a word, separated by snake-case or camel-case boundaries"
  (with-temp-buffer
    (insert-string word)
    (goto-char 0)
    (let (case-fold-search
          (pieces '())
          (accumulate-piece (lambda ()
                              (setq pieces (append pieces (list (filter-buffer-substring 1 (point) t)))))))
      (while (search-forward-regexp "_\\|[a-z][A-Z]" nil t)
        (if (looking-back "_")
            (backward-delete-char 1)
          (backward-char))
        (funcall accumulate-piece))

      (goto-char (point-max))
      (funcall accumulate-piece)

      pieces)))

(defun textmate-case/convert-case (case-format word)
  "convert provided word to camelCase and return as string"
  (with-temp-buffer
    (let ((word-pieces (textmate-case/word-pieces word)))
      (if (or (equal 'camelCase case-format)
              (equal 'PascalCase case-format))
          (progn
            (mapcar (lambda (piece)
                      (save-excursion (insert piece))
                      (capitalize-word 1))
                    word-pieces)
            (if (equal 'camelCase case-format) (downcase-region (point-min) (1+ (point-min)))))
        (progn
          (insert (mapconcat 'identity word-pieces "_"))
          (downcase-region (point-min) (point-max)))))
    (buffer-string)))


(defun textmate-case/toggle (arg)
  "Toggles between camelCase, PascalCase, and snake_case"
  (interactive "p")
  (let* ((bounds (bounds-of-thing-at-point 'symbol))
         (word   (filter-buffer-substring (car bounds) (cdr bounds) t))
         (target-case-format (cond ((textmate-case/snake_case-p word) 'camelCase)
                                   ((textmate-case/camelCase-p word)  'PascalCase)
                                   ((textmate-case/PascalCase-p word) 'snake_case))))
    (insert
     (textmate-case/convert-case target-case-format
                                 word)))
  (if (or (= arg -1) (= arg 2)) (textmate-case/toggle 1)))

(defun textmate-case/toggle2 (arg)
  "Toggles between camelCase and snake_case"
  (interactive "p")
  (let* ((bounds (bounds-of-thing-at-point 'symbol))
         (word   (filter-buffer-substring (car bounds) (cdr bounds) t))
         (target-case-format (cond ((textmate-case/snake_case-p word) 'camelCase)
                                   ((textmate-case/camelCase-p word)  'snake_case))))
    (insert
     (textmate-case/convert-case target-case-format
                                 word)))
  (if (or (= arg -1) (= arg 2)) (textmate-case/toggle 1)))

(global-set-key (kbd "C-c t _") 'textmate-case/toggle)
(global-set-key (kbd "C-c t -") 'textmate-case/toggle)
(global-set-key (kbd "s-_") 'textmate-case/toggle)

(global-set-key (kbd "\C-c C-_") 'textmate-case/toggle2)
(global-set-key (kbd "\C-c C--") 'textmate-case/toggle)

;;----------------------------------------------------------------------
;; toggle-quotes
;;
;; changes quotes around text at point from "str" to 'str' to :str.
;; Don't worry about handling spaces unless there is a region
;; selected, in which case use the region rather than expanding
;; thing-at-point.
(defun toggle-quotes ()
  (interactive)
  ;; expand region to find nearest enclosing quotes or symbol
  ;; if quote-type is ", replace with '
  ;; if quote-type is ' and no spaces, replace with :
  ;; if quote-type is ' and spaces, replace with "
  ;; if quote-type is :, replace with "
  )

(defun print-string-at-point ()
  (interactive)
  (let* ((bounds (bounds-of-thing-at-point 'string)))
    (print bounds)))

;; ;; TODO: tabbar-close-other-tabs receives an event identifying the clicked tab.
;; ;; FIXME: This hangs emacs, especially if any buffers need saving. Avoid using until I'm smarter.
;; (defun reset-all-emacs-tabs ()
;;   "Resets emacs by closing down all tabs: Switches to *scratch* and closes all other tabs"
;;   (interactive)
;;   (switch-to-buffer "*scratch*")
;;   (bury-buffer)
;;   (while (not (eq '*scratch*' (buffer-name)))
;;     (kill-buffer (buffer-name))))


;; Opens an eshell buffer and runs vi in it.
(defun run-vi ()
  (interactive)
  (eshell)
  (switch-to-buffer "*eshell*")
  (insert "vi")
  (eshell-send-input))

;; (defun rails-remote-console ()
;;   (interactive)
;;   (run-ruby "ssh remotehost /apps/my-app/current/script/console"))

(add-hook 'php-mode-hook
          (lambda()
            (require 'php-electric)
            (php-electric-mode nil)
            (setq c-basic-offset 4)
            (indent-tabs-mode t)
            (define-key php-mode-map "\C-cr" 'php-run-file)
            ))

(require 'column-marker)

;; Find ruby18-style :symbol => value hashes and convert them to
;; ruby-19 style symbol: value
(defun convert-ruby18-hashes-to-ruby19 ()
  (interactive)
  (query-replace-regexp ":\\([[:alpha:]][A-Za-z_]*\\)\\([[:space:]]*\\)=>\\([[:space:]]*\\)" "\\1:\\2"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(epg-gpg-program "/usr/local/bin/gpg"))
;; (custom-set-faces
;;   ;; custom-set-faces was added by Custom -- don't edit or cut/paste it!
;;   ;; Your init file should contain only one such instance.
;;  '(default ((t (:stipple nil :background "#ffffff" :foreground "#000000" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :family "adobe-courier")))))

;; are we in aquamacs or carbon emacs?
(defvar *aquamacs-p* (boundp 'aquamacs-version))

(unless *aquamacs-p* ;; Aquamacs does this for us
  (require 'persist-scratch-buffer))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Dear Avdi, I FREAKING LOVE YOU, Love, Dave
(winner-mode 1)

(require 'tidy)