;; Org-mode settings
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)


(setq org-todo-keywords
      '((sequence "TODO(t)"
                  "|" "BLOCKED(b)"
                  "|" "DELEGATED(g)" "WAITING(w)"
                  "|" "DONE(d)" "CANCELLED(c)" "DEFERRED(f)")))
(setq org-tag-alist '(("@work" . ?w) ("@home" . ?h) ("computer" . ?c)
          ("errands" . ?e) ("costco" . ?t) ("grocery" . ?g)
          ("project" . ?p) ("agenda" . ?a)))
(setq org-latex-to-pdf-process '("texi2dvi --pdf --clean --verbose --batch %f"))

(setf org-adapt-indentation t)

(add-hook 'org-mode-hook '(lambda ()
                             (show-all)))


;; ----------------------------------------------------------------------
;; Hat Tip to Tim Harper for code to add checkbox to org-mode when
;; hitting M-enter in a checklist
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
;; ----------------------------------------------------------------------

;; ----------------------------------------------------------------------
;; org-ctrl-c-ctrl-c-and-next-line
;;
;; TODO: next-line until org-at-item-p would be great, it would move
;; me to the next checkbox---UNLESS there are no more items. But how
;; do I tell? ALSO, don't stop on a checkbox if it has children--move
;; to the first childless descendant, that way I can keep checking
;; things off as I go down.
;;
;; NOTE: PDI: When I wrote org-uncheck-everything, I got around all
;; this semantic mess by going to the END of the document and working
;; up. This has the obvious drawback of working only in documents that
;; have exactly one checklist (or this is a feature where "everything"
;; means "EVERYTHING"). However, I recently dug into the org-mode
;; source code and found org-at-item-p, which makes me wonder if there
;; aren't methods like org-item-has-children-p or something
;; similar--I.e. how does org-mode *itself* know there are children,
;; and when it has reached the end of a checklist and should stop
;; counting? TODO: research and interface with this API.
;;
;; TODO: have this work like kmacro-end-and-call-macro, where you hit
;; C-x e to execute the macro, then the minibuffer says "Hit e to
;; execute again". So I'd hit say C-x c, but could then just hit c c c
;; c to continue checking items off. Also C-u n prefix would be nice,
;; and C-x 0 would essentially be "check everything off until end of
;; document". Care would have to be taken to skip over items that have
;; children. See previous note about org-mode API research; ideally
;; the C-u 0 version should stop at the end of the current checklist
;; if there is more than one checklist in the document.
; ----------------------------------------------------------------------
(defun org-ctrl-c-ctrl-c-and-next-line ()
  (interactive)
  (when (org-at-item-p)
    (org-ctrl-c-ctrl-c)
    (next-line)))

(add-hook 'org-mode-hook
          (lambda () (local-set-key (kbd "C-x c") #'org-ctrl-c-ctrl-c-and-next-line)))

;; ----------------------------------------------------------------------
;; KWM: org-insert-journal-title

;; insert e.g. "* 2014-05-09 Fri TODO\n\n\n" at the top of the
;; document. I usually also begin my journal by copying the previous
;; day's journal, so ideally also search for the existence of "*
;; \d\d\d\d-\d\d-\d\d .* TODO" at the top of the document, and if
;; found, delete that line first.
;;
;; Thought: a better defun here might actually be
;; save-journal-as-today or similar, that updates the string, and also
;; writes the file to the new name of YYYY-MM-DD-todo.org.
;; ----------------------------------------------------------------------
(defun replace-first-line-with (string)
  (save-excursion
    (beginning-of-buffer)
    (kill-line)
    (insert string)))

(defun org-insert-journal-title ()
  (interactive)
  (beginning-of-buffer)
  (insert (format-time-string "* %F %a TODO [/]\nM-x o-i-j RET / M-x org-ins<TAB>j<TAB> <RET>\n\n"))
  (previous-line))

(defun org-save-journal-as-today ()
  (interactive)
  (org-insert-journal-title)
  (write-file (format-time-string "%F-todo.org")))

;; ----------------------------------------------------------------------
;; KWM: org-uncheck-everything
;;
;; Note that direction matters: org-ctrl-c-ctrl-c will raise an error
;; (and exit the while loop and the defun) if you try to uncheck an
;; item that has checked subitems. When doing this manually I either
;; ignore these errors (the defun could do this by catching the error)
;; or I check the next line for subitems (the defun could do this by
;; scanning ahead). However, by walking backwards up the document from
;; the bottom, all of this can be avoided, since we now uncheck all
;; child items before reaching the parent item.
;; ----------------------------------------------------------------------
(defun org-uncheck-everything ()
  (interactive)
  (save-excursion
    (end-of-buffer)
    (while (search-forward "[X]" nil t -1)
      (move-end-of-line 1)
      (org-ctrl-c-ctrl-c))))


(provide 'org-config)
