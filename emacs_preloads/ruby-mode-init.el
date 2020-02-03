;; M-x package-install <RET> ruby-hash-syntax <RET>

;; replace selection with interpolated variable
;; e.g. pants => puts "pants: #{pants}"
(fset 'puts-selection-as-interpolation
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("puts \": #{}\"" 0 "%d")) arg)))

(add-hook 'ruby-mode-hook
	  (lambda ()
	    (local-set-key (kbd "\C-c }") 'ruby-toggle-hash-syntax)
	    (local-set-key (kbd "\C-c C-t") 'comment-todo-erest-1895)
	    (local-set-key (kbd "\C-c #") 'puts-selection-as-interpolation)
            (fci-mode 't)
	  ))



;; align-json-hash
;; Okay, you can do proper json-style alignment (adding spaces AFTER the colon)
;; with this command:
;; C-u M-x align-regexp <RET> \(\s-*\):\(\s-*\) <RET> <BKSP> 2 <RET> <RET>
(fset 'align-json-hash
      (lambda (&optional arg) "Keyboard macro." (interactive "p")
      (kmacro-exec-ring-item (quote
			      ("xalign-regexp:\\(\\s-*\\)2y" 0 "%d")) arg)))
(global-set-key (kbd "\C-x :") 'align-json-hash)
