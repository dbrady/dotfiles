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
