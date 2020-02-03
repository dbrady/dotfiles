;; terminal-hacks.el
;; Because not all terminals are created equal, and many of them refuse to send C-M-S-5 for query-replace-regexp
(global-set-key (kbd "C-M-y") 'query-replace-regexp)
