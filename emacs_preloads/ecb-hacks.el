;; ECB Hacks


;; Brutish hack to search for the definition of a symbol/type/function
;; Taken from https://www.emacswiki.org/emacs/JumpToDefinition
(defun find-definition (arg)
      "Jump to the definition of the symbol, type or function at point.
  With prefix arg, find in other window."
      (interactive "P")
      (let* ((tag (or (semantic-idle-summary-current-symbol-info-context)
                      (semantic-idle-summary-current-symbol-info-brutish)
                      (error "No known tag at point")))
             (pos (or (semantic-tag-start tag)
                      (error "Tag definition not found")))
             (file (semantic-tag-file-name tag)))
        (if file
            (if arg (find-file-other-window file) (find-file file))
          (if arg (switch-to-buffer-other-window (current-buffer))))
        (push-mark)
        (goto-char pos)
              (end-of-line)))
