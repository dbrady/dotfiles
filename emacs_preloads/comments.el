;; Graciously provided by ams on irc.freenode.net:#emacs
;; Returns starting point of match if found, else nil
(defun string-ends-with (regexp string)
  (string-match (concat regexp "$") string))

;; Returns 0 if true, else nil
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

;; dbrady 2018-04-11: Stealing C-c #. I want this binding to replace (selection)
;; with puts "selection: #{selection}"
;;(global-set-key (kbd "\C-c #") 'comment-name-and-date)
(global-set-key (kbd "\C-c @") 'insert-date)
(global-set-key (kbd "\C-c -") 'insert-comment-bar)
(global-set-key (kbd "\C-c =") 'insert-comment-bar-major)

;;----------------------------------------------------------------------
;; comment-todo-story
;; Inserts a comment string and TODO: <story-name> followed by a hyphen
;; C-c ! !            => "# TODO: PRO-1322-SPIKE-remove-autostart - "
;; C-c ! ? <name>     => queries for branch name and saves it to ~/.emacs-todo-story-name
;; C-u <name> C-c ! ? => sets todo story name name directly
;;
;; TODO: Write the second two defuns; right now this changes rarely enoughthat
;; I can just jam it directly into this source. Stories change daily or it's
;; maybe once a month that I have a story big enough that I need to start
;; leaving a trail of breadcrumbs
(defun comment-todo-story ()
  (interactive)
  (insert (safe-comment-start) "TODO: PRO-1322-SPIKE - " (safe-comment-end)))
(global-set-key (kbd "\C-c ! !") 'comment-todo-story)
