;; Some modes that should auto-fill by default
(add-hook 'markdown-mode-hook 'auto-fill-mode)

;; ----------------------------------------------------------------------
;; TODO: Make org-mode and markdown-mode play nicely together
;; ----------------------------------------------------------------------
;;
;; - [ ] Set commands here that are free in both modes to toggle the
;;   modes. Either globally set a fixed pair of "go to md mode", "go to
;;   org-mode", or set a single keybindng in org-mode that goes to markdown and
;;   in markdown that goes to org-mode.
;;
;; - [ ] Write some emacslisp that converts markdown tables to
;;   orgmode. Specifically, it changes |----|-----|-----| in the table headers
;;   to |----+----+----|, which breaks markdown rendering. This script should be
;;   invoked run any time I invoke my "go to markdown mode from org mode"
;;   command, and possibly before I save a file in markdown mode.
;;
;; - [ ] ALTERNATELY: org-mode seems to read |----|----|-----| just fine. Any
;;   way to customize it to WRITE that style, too? Then they'd be implicitly
;;   cooperative.
;;
;; - [ ] Honestly the thing I need most right now is the ability to align a
;;   table the way org-mode does, but without leaving markdown-mode. Doable?
;;   Ideally without having to select the entire table. If the table is known to
;;   be marked in advance, then (narrow-to-region) (org-mode 't) (orgtbl-tab)
;;   (markdown-mode 't) (widen) should just about cover it. Heck, could even put
;;   that in a macro.
;;
;;
;; TODO: Investigate MuMaMo or some other modern feature that might let me edit
;; a markdown file but detect tables and automagically invoke org-table-mode
;; when I'm in that region. MuMaMo was known to be problematic the last time I
;; looked at it (2015 maybe?) so by now I'm sure there have been changes. What I
;; don't know is if the general problem has now become well-solved, or if the
;; problem has been declared NP-hard and officially abandoned and deprecated and
;; identified as a "you probabyl don't want to do that" sort of thing.
;; ----------------------------------------------------------------------

;; Use Github-Flavored-Markdown
;; This will need the "flavor" script written by Brett Terpstra:
;; http://brettterpstra.com/2012/09/16/easy-command-line-github-flavored-markdown/
;;
;; Brett has published his script here: https://gist.github.com/ttscoff/3732963
;;
;; And I have a copy of it in my personal bin folder at https://github.com/dbrady/bin/blob/master/flavor
;;
;; Stick that in the path and make sure whatever ruby emacs tries to reach for
;; has the json gem installed, e.g. on a new machine try
;;
;; rvm @global do rvm gem install json
;; (setq markdown-command "/usr/local/bin/flavor")
