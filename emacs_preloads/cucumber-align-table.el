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
