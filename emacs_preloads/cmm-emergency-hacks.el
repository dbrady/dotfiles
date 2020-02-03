(global-set-key (kbd "\C-c M-f") 'auto-fill-mode)
(global-linum-mode 1)

(global-set-key (kbd "\C-x C-r") 'recentf-open-files)
(global-set-key (kbd "\C-c /") 'comment-dwim)

(set-face-attribute 'default nil :height 140)

(add-hook 'before-save-hook 'whitespace-cleanup)

(setq-default fill-column 80)
